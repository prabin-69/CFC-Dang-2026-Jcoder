import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../core/utils.dart';

class ChatService extends ChangeNotifier {
  final List<ChatModel> _chats = [];
  final Map<String, List<ChatMessageModel>> _messages = {};
  bool _isLoading = false;

  List<ChatModel> get chats {
    return List.from(_chats)..sort((a, b) {
      if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
      if (a.lastMessageTime == null) return 1;
      if (b.lastMessageTime == null) return -1;
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });
  }

  bool get isLoading => _isLoading;

  ChatService() {
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();

    _chats.addAll([
      ChatModel(
        id: 'chat1',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p1',
        professionalName: 'Ramesh Shrestha',
        lastMessage: 'Yes, I can come tomorrow at 10 AM',
        lastMessageTime: now.subtract(const Duration(minutes: 30)),
        unreadCount: 2,
        bookingId: 'b1',
      ),
      ChatModel(
        id: 'chat2',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p2',
        professionalName: 'Sita Maharjan',
        lastMessage: 'I will send the quotation by evening',
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 0,
        bookingId: 'b2',
      ),
      ChatModel(
        id: 'chat3',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p3',
        professionalName: 'Hari KC',
        lastMessage: 'The bookshelf is ready for delivery',
        lastMessageTime: now.subtract(const Duration(days: 2)),
        unreadCount: 0,
        bookingId: 'b3',
      ),
    ]);

    // Add messages for chat1
    _messages['chat1'] = [
      ChatMessageModel(
        id: 'm1',
        chatId: 'chat1',
        senderId: 'p1',
        senderName: 'Ramesh Shrestha',
        message:
            'Hello! I received your booking request for water heater repair.',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm2',
        chatId: 'chat1',
        senderId: 'c1',
        senderName: 'Anita Gurung',
        message: 'Hi Ramesh, when can you come?',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm3',
        chatId: 'chat1',
        senderId: 'p1',
        senderName: 'Ramesh Shrestha',
        message: 'I can come tomorrow at 10 AM. Is that okay?',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm4',
        chatId: 'chat1',
        senderId: 'c1',
        senderName: 'Anita Gurung',
        message: 'Yes, that works perfectly!',
        messageType: 'text',
        timestamp: now.subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm5',
        chatId: 'chat1',
        senderId: 'p1',
        senderName: 'Ramesh Shrestha',
        message:
            'Great! See you tomorrow. Please make sure the water supply is accessible.',
        messageType: 'text',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      ChatMessageModel(
        id: 'm6',
        chatId: 'chat1',
        senderId: 'p1',
        senderName: 'Ramesh Shrestha',
        message: 'Yes, I can come tomorrow at 10 AM',
        messageType: 'text',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];

    _messages['chat2'] = [
      ChatMessageModel(
        id: 'm7',
        chatId: 'chat2',
        senderId: 'c1',
        senderName: 'Anita Gurung',
        message: 'Hi Sita, I need some electrical work done.',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm8',
        chatId: 'chat2',
        senderId: 'p2',
        senderName: 'Sita Maharjan',
        message: 'Hello! Sure, can you describe the work?',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 30)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm9',
        chatId: 'chat2',
        senderId: 'c1',
        senderName: 'Anita Gurung',
        message: 'I need complete wiring for a new room addition.',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm10',
        chatId: 'chat2',
        senderId: 'p2',
        senderName: 'Sita Maharjan',
        message: 'I will send the quotation by evening',
        messageType: 'text',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
    ];

    notifyListeners();
  }

  List<ChatMessageModel> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  ChatModel? getChatById(String id) {
    try {
      return _chats.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    final newMessage = ChatMessageModel(
      id: AppUtils.generateId(),
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _messages[chatId] = [...(_messages[chatId] ?? []), newMessage];

    // Update last message in chat list
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = ChatModel(
        id: _chats[chatIndex].id,
        customerId: _chats[chatIndex].customerId,
        customerName: _chats[chatIndex].customerName,
        customerPhotoUrl: _chats[chatIndex].customerPhotoUrl,
        professionalId: _chats[chatIndex].professionalId,
        professionalName: _chats[chatIndex].professionalName,
        professionalPhotoUrl: _chats[chatIndex].professionalPhotoUrl,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        unreadCount: senderId == 'p1' ? _chats[chatIndex].unreadCount + 1 : 0,
        bookingId: _chats[chatIndex].bookingId,
      );
    }

    notifyListeners();
  }

  void markAsRead(String chatId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = ChatModel(
        id: _chats[chatIndex].id,
        customerId: _chats[chatIndex].customerId,
        customerName: _chats[chatIndex].customerName,
        customerPhotoUrl: _chats[chatIndex].customerPhotoUrl,
        professionalId: _chats[chatIndex].professionalId,
        professionalName: _chats[chatIndex].professionalName,
        professionalPhotoUrl: _chats[chatIndex].professionalPhotoUrl,
        lastMessage: _chats[chatIndex].lastMessage,
        lastMessageTime: _chats[chatIndex].lastMessageTime,
        unreadCount: 0,
        bookingId: _chats[chatIndex].bookingId,
      );
    }
    notifyListeners();
  }
}
