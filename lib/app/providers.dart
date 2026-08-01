import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../services/professional_service.dart';
import '../services/booking_service.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';
import '../services/ai_service.dart';
import '../services/theme_service.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/professional/domain/repositories/professional_repository.dart';
import '../features/booking/domain/repositories/booking_repository.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/notification/domain/repositories/notification_repository.dart';

import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/professional/data/repositories/professional_repository_impl.dart';
import '../features/booking/data/repositories/booking_repository_impl.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/notification/data/repositories/notification_repository_impl.dart';
import '../features/auth/domain/entities/user_entity.dart';

// ──────────────────────────────────────────────
//  ChangeNotifier-backed service providers
//  (Existing services wrapped as Riverpod providers)
// ──────────────────────────────────────────────

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

final professionalServiceProvider = ChangeNotifierProvider<ProfessionalService>(
  (ref) {
    return ProfessionalService();
  },
);

final bookingServiceProvider = ChangeNotifierProvider<BookingService>((ref) {
  return BookingService();
});

final chatServiceProvider = ChangeNotifierProvider<ChatService>((ref) {
  return ChatService();
});

final notificationServiceProvider = ChangeNotifierProvider<NotificationService>(
  (ref) {
    return NotificationService();
  },
);

final aiServiceProvider = ChangeNotifierProvider<AIAssistantService>((ref) {
  return AIAssistantService();
});

final aiAssistantServiceProvider = ChangeNotifierProvider<AIAssistantService>((
  ref,
) {
  return AIAssistantService();
});

final themeServiceProvider = ChangeNotifierProvider<ThemeService>((ref) {
  return ThemeService();
});

// ──────────────────────────────────────────────
//  Repository providers (wrapping services)
// ──────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  final service = ref.watch(professionalServiceProvider);
  return ProfessionalRepositoryImpl(service);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final service = ref.watch(bookingServiceProvider);
  return BookingRepositoryImpl(service);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final service = ref.watch(chatServiceProvider);
  return ChatRepositoryImpl(service);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationRepositoryImpl(service);
});

// ──────────────────────────────────────────────
//  Theme mode provider (derived from ThemeService)
// ──────────────────────────────────────────────

final themeModeProvider = Provider<ThemeMode>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return themeService.themeMode;
});

// ──────────────────────────────────────────────
//  Auth state providers
// ──────────────────────────────────────────────

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser != null && !authRepo.isGuestMode;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser;
});

final currentRoleProvider = Provider<String>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentRole;
});

// ──────────────────────────────────────────────
//  Notifications provider
// ──────────────────────────────────────────────

final unreadCountProvider = Provider<int>((ref) {
  final notifRepo = ref.watch(notificationRepositoryProvider);
  return notifRepo.unreadCount;
});
