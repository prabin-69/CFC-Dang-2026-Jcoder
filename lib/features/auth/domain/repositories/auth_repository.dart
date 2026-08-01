import '../entities/user_entity.dart';

/// Abstract repository for authentication & user management.
abstract class AuthRepository {
  UserEntity? get currentUser;
  bool get isLoading;
  bool get isGuestMode;
  String get currentRole;

  Future<void> sendOtp(String phone);
  Future<bool> verifyOtp(String phone, String otp);
  Future<void> updateProfile({
    required String name,
    String? photoUrl,
    String? bio,
    String? location,
    String? role,
    List<String>? skills,
    String? experience,
  });
  void enterGuestMode();
  Future<void> logout();
  Future<void> refreshUser();
}
