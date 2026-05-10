import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../security/security_tactics.dart';
import 'audit_service.dart';

class AuthResult {
  const AuthResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class PrototypeAuthService extends ChangeNotifier {
  PrototypeAuthService(this._auditService);

  final AuditService _auditService;
  final PrototypeRateLimiter _adminRateLimiter = PrototypeRateLimiter();

  AppUser _currentUser = const AppUser(
    id: 'guest',
    displayName: 'Зочин',
    role: UserRole.guest,
  );

  AppUser get currentUser => _currentUser;
  bool get isLoggedIn => !_currentUser.isGuest;
  bool get isAdmin => _currentUser.isAdmin;
  bool get adminLoginLocked => _adminRateLimiter.isLocked;
  Duration? get adminLockRemaining => _adminRateLimiter.remainingLockTime;

  AuthResult continueAsGuest() {
    _currentUser = const AppUser(id: 'guest', displayName: 'Зочин', role: UserRole.guest);
    _auditService.record(action: 'guest_mode', actor: 'guest', message: 'Бүртгэлгүй хэрэглэгчээр үргэлжлэв');
    notifyListeners();
    return const AuthResult(success: true, message: 'Бүртгэлгүй хэрэглэгчээр үргэлжилж байна.');
  }

  AuthResult signInWithPhone({
    required String displayName,
    required String localPhoneDigits,
    required int age,
    required String password,
  }) {
    final cleanName = InputSanitizer.cleanText(displayName, maxLength: 48);

    if (cleanName.isEmpty) {
      return const AuthResult(success: false, message: 'Нэрээ оруулна уу.');
    }
    if (!MongolianPhoneValidator.isValidLocalNumber(localPhoneDigits)) {
      return const AuthResult(success: false, message: 'Утасны дугаар 8 оронтой байх ёстой.');
    }
    if (age < 13) {
      return const AuthResult(success: false, message: 'Насны шаардлага хангахгүй байна.');
    }
    if (password.trim().length < 4) {
      return const AuthResult(success: false, message: 'Нууц үг хамгийн багадаа 4 тэмдэгт байна.');
    }

    final phone = MongolianPhoneValidator.normalize(localPhoneDigits);
    _currentUser = AppUser(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      displayName: cleanName,
      role: UserRole.user,
      phoneNumber: phone,
      age: age,
      isVerified: true,
    );
    _auditService.record(action: 'login_user', actor: cleanName, message: 'Утасны дугаараар хэрэглэгч нэвтэрлээ: $phone');
    notifyListeners();
    return const AuthResult(success: true, message: 'Амжилттай нэвтэрлээ.');
  }

  AuthResult signInAdmin({required String username, required String password}) {
    if (_adminRateLimiter.isLocked) {
      final seconds = _adminRateLimiter.remainingLockTime?.inSeconds ?? 45;
      return AuthResult(success: false, message: 'Олон буруу оролдлого хийсэн тул $seconds секунд хүлээнэ үү.');
    }

    if (username.trim() == 'admin' && password == 'pass') {
      _adminRateLimiter.registerSuccess();
      _currentUser = const AppUser(
        id: 'admin-1',
        displayName: 'Системийн админ',
        role: UserRole.admin,
        isVerified: true,
      );
      _auditService.record(action: 'login_admin', actor: 'admin', message: 'Админ амжилттай нэвтэрлээ');
      notifyListeners();
      return const AuthResult(success: true, message: 'Админ самбар руу орлоо.');
    }

    _adminRateLimiter.registerFailure();
    _auditService.record(action: 'login_failed', actor: username.trim().isEmpty ? 'unknown' : username.trim(), message: 'Админ нэвтрэлтийн буруу оролдлого');
    return const AuthResult(success: false, message: SecurityMessages.genericLoginError);
  }

  void logout() {
    final actor = _currentUser.displayName;
    _auditService.record(action: 'logout', actor: actor, message: '$actor системээс гарлаа');
    _currentUser = const AppUser(id: 'guest', displayName: 'Зочин', role: UserRole.guest);
    notifyListeners();
  }
}
