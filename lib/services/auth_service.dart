import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/constants.dart';
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
  bool get isAdmin => _currentUser?.role == AppConstants.roleAdmin;
  bool get isCustomer => _currentUser?.role == AppConstants.roleCustomer;
  bool get isProfessional =>
      _currentUser?.role == AppConstants.roleProfessional;
  bool get isBusiness => _currentUser?.role == AppConstants.roleBusiness;

  /// Check if an action is restricted for guest users.
  /// Returns true if the user is a guest and the action requires login.
  bool isActionRestricted(String action) {
    if (!_isGuestMode) return false;
    // All guest-restricted actions require login
    return true;
  }

  /// Prompt the user to log in when trying a restricted action.
  /// Returns true if the action should be blocked.
  bool guardAction(BuildContext context, String action) {
    if (!isActionRestricted(action)) return false;
    _showLoginSheet(context);
    return true;
  }

  void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _GuestLoginSheet(),
    );
  }

  String get currentRole {
    if (_isGuestMode) return AppConstants.roleGuest;
    return _currentUser?.role ?? AppConstants.roleGuest;
  }

  Future<void> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    // Just mark as verified, profile completion will finish setup
    _currentUser = UserModel(
      id: AppUtils.generateId(),
      name: '',
      phone: phone,
      role: AppConstants.roleCustomer,
      isVerified: true,
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
    String? experience,
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
      role: AppConstants.roleCustomer,
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

/// Bottom sheet prompting guests to sign in
class _GuestLoginSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign in to continue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create an account or sign in to book professionals, send messages, and more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/auth');
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue as Guest'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
