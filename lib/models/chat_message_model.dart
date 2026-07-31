class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String message;
  final String messageType; // text, image, file
  final String? fileUrl;
  final DateTime timestamp;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.message,
    this.messageType = 'text',
    this.fileUrl,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'message': message,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'],
      message: map['message'] ?? '',
      messageType: map['messageType'] ?? 'text',
      fileUrl: map['fileUrl'],
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      isRead: map['isRead'] ?? false,
    );
  }
}

class ChatModel {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerPhotoUrl;
  final String professionalId;
  final String professionalName;
  final String? professionalPhotoUrl;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final String? bookingId;

  ChatModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhotoUrl,
    required this.professionalId,
    required this.professionalName,
    this.professionalPhotoUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.bookingId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhotoUrl': customerPhotoUrl,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalPhotoUrl': professionalPhotoUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'bookingId': bookingId,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhotoUrl: map['customerPhotoUrl'],
      professionalId: map['professionalId'] ?? '',
      professionalName: map['professionalName'] ?? '',
      professionalPhotoUrl: map['professionalPhotoUrl'],
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime'])
          : null,
      unreadCount: map['unreadCount'] ?? 0,
      bookingId: map['bookingId'],
    );
  }
}
