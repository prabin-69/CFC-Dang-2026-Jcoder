import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../services/auth_service.dart';
import '../../services/booking_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final bookingService = context.watch<BookingService>();
    final user = authService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
          if (authService.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_rounded),
              onPressed: () => context.go('/admin'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (authService.isGuestMode)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Guest Mode',
                      style: TextStyle(color: AppColors.warning, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileStat(
                label: 'Bookings',
                value: '${bookingService.bookings.length}',
                icon: Icons.book_online_rounded,
              ),
              _ProfileStat(
                label: 'Requests',
                value: '${bookingService.serviceRequests.length}',
                icon: Icons.request_page_rounded,
              ),
              _ProfileStat(
                label: 'Reviews',
                value: '0',
                icon: Icons.reviews_rounded,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Menu Items
          const Text(
            'Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ProfileMenuItem(
            icon: Icons.person_rounded,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.location_on_rounded,
            title: 'My Address',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            onTap: () => context.go('/notifications'),
          ),
          _ProfileMenuItem(
            icon: Icons.security_rounded,
            title: 'Privacy & Security',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.help_rounded,
            title: 'Help & Support',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.info_rounded,
            title: 'About WorkLink',
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Logout
          if (!authService.isGuestMode)
            OutlinedButton.icon(
              onPressed: () {
                authService.logout();
                context.go('/auth');
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => context.go('/auth'),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign In'),
            ),

          const SizedBox(height: 32),

          // Version
          Center(
            child: Text(
              'WorkLink v1.0.0',
              style: TextStyle(
                color: AppColors.textHint.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textHint,
        ),
        onTap: onTap,
      ),
    );
  }
}
