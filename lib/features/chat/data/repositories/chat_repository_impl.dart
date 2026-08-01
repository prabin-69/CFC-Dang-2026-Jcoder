import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../../services/chat_service.dart';

/// Mock implementation of [ChatRepository] backed by existing ChatService.
class ChatRepositoryImpl implements ChatRepository {
  final ChatService _service;

  ChatRepositoryImpl(this._service);

  @override
  List<ChatModel> get chats => _service.chats;

  @override
  bool get isLoading => _service.isLoading;

  @override
  List<ChatMessageModel> getMessages(String chatId) =>
      _service.getMessages(chatId);

  @override
  ChatModel? getChatById(String id) => _service.getChatById(id);

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  }) => _service.sendMessage(
    chatId: chatId,
    senderId: senderId,
    senderName: senderName,
    message: message,
  );

  @override
  void markAsRead(String chatId) => _service.markAsRead(chatId);
}
