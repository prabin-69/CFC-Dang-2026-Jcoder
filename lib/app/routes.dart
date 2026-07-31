import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/otp_verification_screen.dart';
import '../features/auth/profile_completion_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/customer_dashboard_screen.dart';
import '../features/home/professional_dashboard_screen.dart';
import '../features/professionals/professional_detail_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/booking/create_service_request_screen.dart';
import '../features/booking/quotation_screen.dart';
import '../features/booking/my_bookings_screen.dart';
import '../features/booking/booking_detail_screen.dart';
import '../features/chat/chat_list_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/ai/ai_assistant_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpVerificationScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/profile-completion',
      builder: (context, state) => const ProfileCompletionScreen(),
    ),

    // --- Role-based Shell ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home/Dashboard (role-aware)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) {
                final authService = context.watch<AuthService>();
                final role = authService.currentRole;
                if (role == AppConstants.roleProfessional ||
                    role == AppConstants.roleBusiness) {
                  return const ProfessionalDashboardScreen();
                }
                return const CustomerDashboardScreen();
              },
            ),
          ],
        ),

        // Branch 1: Bookings (customer) / Jobs (professional) / Team (business)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              builder: (context, state) => const MyBookingsScreen(),
            ),
          ],
        ),

        // Branch 2: Chat
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat-list',
              builder: (context, state) => const ChatListScreen(),
            ),
          ],
        ),

        // Branch 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // --- Detail Routes ---
    GoRoute(
      path: '/professional-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProfessionalDetailScreen(professionalId: id);
      },
    ),
    GoRoute(
      path: '/booking/:professionalId',
      builder: (context, state) {
        final professionalId = state.pathParameters['professionalId'] ?? '';
        return BookingScreen(professionalId: professionalId);
      },
    ),
    GoRoute(
      path: '/ai-assistant',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      path: '/create-service-request',
      builder: (context, state) => const CreateServiceRequestScreen(),
    ),
    GoRoute(
      path: '/quotations/:requestId',
      builder: (context, state) {
        final requestId = state.pathParameters['requestId'] ?? '';
        return QuotationScreen(requestId: requestId);
      },
    ),
    GoRoute(
      path: '/booking-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return BookingDetailScreen(bookingId: id);
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId'] ?? '';
        return ChatScreen(chatId: chatId);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
