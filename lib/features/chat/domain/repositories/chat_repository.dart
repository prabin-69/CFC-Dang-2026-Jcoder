import '../entities/chat_entity.dart';

/// Abstract repository for real-time chat.
abstract class ChatRepository {
  List<ChatModel> get chats;
  bool get isLoading;

  List<ChatMessageModel> getMessages(String chatId);
  ChatModel? getChatById(String id);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  });

  void markAsRead(String chatId);
}
