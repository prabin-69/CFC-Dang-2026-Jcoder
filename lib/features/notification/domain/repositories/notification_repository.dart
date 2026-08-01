import '../entities/notification_entity.dart';

/// Abstract repository for in-app notifications.
abstract class NotificationRepository {
  List<AppNotification> get notifications;
  int get unreadCount;

  void markAsRead(String notificationId);
  void markAllAsRead();
}
