import '../../../professional/domain/entities/professional_entity.dart';

/// Action types the AI assistant can present to the user.
enum AiActionType { viewProfessionals, createRequest, viewBookings, none }

/// A structured action (button) attached to an AI message.
class AiAction {
  final AiActionType type;
  final String label;
  final String? payload;

  const AiAction({required this.type, required this.label, this.payload});
}

/// A single chat message in the AI assistant conversation.
class AiChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<AiAction> actions;
  final List<ProfessionalModel>? recommendedProfessionals;
  final String? suggestedCategory;
  final String? suggestedTitle;
  final String? suggestedDescription;
  final bool isTyping;

  const AiChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actions = const [],
    this.recommendedProfessionals,
    this.suggestedCategory,
    this.suggestedTitle,
    this.suggestedDescription,
    this.isTyping = false,
  });

  AiChatMessage copyWith({bool? isTyping}) {
    return AiChatMessage(
      text: text,
      isUser: isUser,
      timestamp: timestamp,
      actions: actions,
      recommendedProfessionals: recommendedProfessionals,
      suggestedCategory: suggestedCategory,
      suggestedTitle: suggestedTitle,
      suggestedDescription: suggestedDescription,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
