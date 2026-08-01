import '../entities/ai_entity.dart';

/// Abstract repository for the AI Assistant engine.
abstract class AIRepository {
  List<AiChatMessage> get messages;
  bool get isTyping;
  bool get awaitingInput;

  Future<void> sendMessage(String input);
  Future<void> sendImageMessage(String imagePath);
}
