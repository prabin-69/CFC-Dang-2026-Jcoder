import 'package:flutter/material.dart';
import '../core/utils.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // booking, message, quotation, system
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
  });
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications {
    return List.from(_notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  int get unreadCount => _unreadCount;

  NotificationService() {
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();

    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Booking Confirmed',
        body:
            'Ramesh Shrestha has confirmed your booking for water heater repair.',
        type: 'booking',
        relatedId: 'b1',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      AppNotification(
        id: 'n2',
        title: 'New Quotation Received',
        body:
            'Gopal Tamang has submitted a quotation for your plumbing service request.',
        type: 'quotation',
        relatedId: 'sr1',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 'n3',
        title: 'New Message',
        body: 'You have a new message from Ramesh Shrestha.',
        type: 'message',
        relatedId: 'chat1',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      AppNotification(
        id: 'n4',
        title: 'Welcome to WorkLink',
        body:
            'Thank you for joining WorkLink! Start exploring professionals near you.',
        type: 'system',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ]);

    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        body: _notifications[index].body,
        type: _notifications[index].type,
        relatedId: _notifications[index].relatedId,
        isRead: true,
        createdAt: _notifications[index].createdAt,
      );
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = AppNotification(
        id: _notifications[i].id,
        title: _notifications[i].title,
        body: _notifications[i].body,
        type: _notifications[i].type,
        relatedId: _notifications[i].relatedId,
        isRead: true,
        createdAt: _notifications[i].createdAt,
      );
    }
    _unreadCount = 0;
    notifyListeners();
  }
}
