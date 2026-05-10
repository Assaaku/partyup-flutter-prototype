enum UserRole { guest, user, organizer, admin }

class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.role,
    this.phoneNumber,
    this.age,
    this.isVerified = false,
  });

  final String id;
  final String displayName;
  final UserRole role;
  final String? phoneNumber;
  final int? age;
  final bool isVerified;

  bool get isGuest => role == UserRole.guest;
  bool get isAdmin => role == UserRole.admin;
  bool get canCreateEvent => role == UserRole.user || role == UserRole.organizer || role == UserRole.admin;

  String get roleLabel {
    switch (role) {
      case UserRole.guest:
        return 'Бүртгэлгүй хэрэглэгч';
      case UserRole.user:
        return 'Энгийн хэрэглэгч';
      case UserRole.organizer:
        return 'Зохион байгуулагч';
      case UserRole.admin:
        return 'Админ';
    }
  }
}
