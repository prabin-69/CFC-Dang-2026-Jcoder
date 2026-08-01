import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../services/auth_service.dart';

/// Mock implementation of [AuthRepository] backed by the existing AuthService.
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  UserEntity? get currentUser {
    final u = _authService.currentUser;
    if (u == null) return null;
    return UserEntity(
      id: u.id,
      name: u.name,
      email: u.email,
      phone: u.phone,
      photoUrl: u.photoUrl,
      role: u.role,
      bio: u.bio,
      location: u.location,
      rating: u.rating,
      reviewCount: u.reviewCount,
      skills: u.skills,
      isVerified: u.isVerified,
      isAvailable: u.isAvailable,
      createdAt: u.createdAt,
      updatedAt: u.updatedAt,
    );
  }

  @override
  bool get isLoading => _authService.isLoading;

  @override
  bool get isGuestMode => _authService.isGuestMode;

  @override
  String get currentRole => _authService.currentRole;

  @override
  Future<void> sendOtp(String phone) => _authService.sendOtp(phone);

  @override
  Future<bool> verifyOtp(String phone, String otp) =>
      _authService.verifyOtp(phone, otp);

  @override
  Future<void> updateProfile({
    required String name,
    String? photoUrl,
    String? bio,
    String? location,
    String? role,
    List<String>? skills,
    String? experience,
  }) => _authService.updateProfile(
    name: name,
    photoUrl: photoUrl,
    bio: bio,
    location: location,
    role: role,
    skills: skills,
    experience: experience,
  );

  @override
  void enterGuestMode() => _authService.enterGuestMode();

  @override
  Future<void> logout() => _authService.logout();

  @override
  Future<void> refreshUser() => _authService.refreshUser();
}
