import 'package:flutter/services.dart';

class MongolianPhoneValidator {
  static final RegExp _digitsOnly = RegExp(r'^\d{8}$');

  static bool isValidLocalNumber(String value) {
    return _digitsOnly.hasMatch(value.trim());
  }

  static String normalize(String localDigits) {
    return '+976 ${localDigits.trim()}';
  }
}

class EightDigitPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;
    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

class InputSanitizer {
  static String cleanText(String value, {int maxLength = 280}) {
    final withoutDangerousCharacters = value
        .replaceAll(RegExp(r'[<>]'), '')
        .replaceAll(RegExp(r'[\u0000-\u001F]'), ' ')
        .trim();
    if (withoutDangerousCharacters.length <= maxLength) {
      return withoutDangerousCharacters;
    }
    return withoutDangerousCharacters.substring(0, maxLength).trim();
  }
}

class PrototypeRateLimiter {
  PrototypeRateLimiter({
    this.maxAttempts = 5,
    this.lockDuration = const Duration(seconds: 45),
  });

  final int maxAttempts;
  final Duration lockDuration;
  int _failedAttempts = 0;
  DateTime? _lockedUntil;

  bool get isLocked {
    final lockedUntil = _lockedUntil;
    if (lockedUntil == null) return false;
    if (DateTime.now().isAfter(lockedUntil)) {
      _lockedUntil = null;
      _failedAttempts = 0;
      return false;
    }
    return true;
  }

  Duration? get remainingLockTime {
    final lockedUntil = _lockedUntil;
    if (lockedUntil == null || !isLocked) return null;
    return lockedUntil.difference(DateTime.now());
  }

  void registerFailure() {
    _failedAttempts += 1;
    if (_failedAttempts >= maxAttempts) {
      _lockedUntil = DateTime.now().add(lockDuration);
    }
  }

  void registerSuccess() {
    _failedAttempts = 0;
    _lockedUntil = null;
  }
}

class SecurityMessages {
  static const genericLoginError = 'Нэвтрэх мэдээлэл буруу эсвэл эрх хүрэлцэхгүй байна.';
  static const guestNeedsLogin = 'Энэ үйлдлийг хийхийн тулд эхлээд нэвтэрнэ үү.';
}
