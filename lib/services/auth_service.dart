import 'package:flutter/material.dart';
import '../core/utils.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isGuestMode = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isGuestMode => _isGuestMode;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<void> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    // Simulate OTP sending
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    // Create a new user
    _currentUser = UserModel(
      id: AppUtils.generateId(),
      name: 'User',
      phone: phone,
      role: 'customer',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _isLoading = false;
    _isGuestMode = false;
    notifyListeners();
    return true;
  }

  Future<void> updateProfile({
    required String name,
    String? photoUrl,
    String? bio,
    String? location,
    String? role,
    List<String>? skills,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        photoUrl: photoUrl,
        bio: bio,
        location: location,
        role: role,
        skills: skills,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void enterGuestMode() {
    _isGuestMode = true;
    _currentUser = UserModel(
      id: 'guest_${AppUtils.generateId()}',
      name: 'Guest',
      phone: '',
      role: 'customer',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isGuestMode = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    notifyListeners();
  }
}
