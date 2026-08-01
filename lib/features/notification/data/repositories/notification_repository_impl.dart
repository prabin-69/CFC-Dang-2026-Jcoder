import '../../domain/repositories/notification_repository.dart';
import '../../../../services/notification_service.dart';

/// Mock implementation of [NotificationRepository] backed by NotificationService.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _service;

  NotificationRepositoryImpl(this._service);

  @override
  List<AppNotification> get notifications => _service.notifications;

  @override
  int get unreadCount => _service.unreadCount;

  @override
  void markAsRead(String notificationId) => _service.markAsRead(notificationId);

  @override
  void markAllAsRead() => _service.markAllAsRead();
}
