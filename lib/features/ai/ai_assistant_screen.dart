import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../app/providers.dart';
import '../../services/ai_service.dart';
import 'widgets/ai_message_bubble.dart';
import 'widgets/ai_quick_suggestions.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final aiService = ref.read(aiAssistantServiceProvider);
    final professionals = ref.read(professionalServiceProvider).professionals;
    await aiService.sendMessage(text, professionals: professionals);
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (image == null) return;

    final aiService = ref.read(aiAssistantServiceProvider);
    final professionals = ref.read(professionalServiceProvider).professionals;
    await aiService.sendImageMessage(image.path, professionals: professionals);
    _scrollToBottom();
  }

  void _handleAction(AiActionType type, String? payload) {
    switch (type) {
      case AiActionType.viewProfessionals:
        if (payload != null) {
          ref.read(professionalServiceProvider).setSelectedCategory(payload);
        }
        context.go('/home');
        break;
      case AiActionType.createRequest:
        context.go('/create-service-request');
        break;
      case AiActionType.viewBookings:
        context.go('/bookings');
        break;
      case AiActionType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(aiAssistantServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryLight],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Smart service guide',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              // Refresh: clear and restart
              // For MVP, we let the user keep talking
              AppUtils.showSnackBar(context, 'Keep describing your problem!');
            },
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: aiService.messages.length,
              itemBuilder: (context, index) {
                final message = aiService.messages[index];
                return AiMessageBubble(
                  message: message,
                  onAction: _handleAction,
                );
              },
            ),
          ),

          // Typing indicator
          if (aiService.isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildDot(0), _buildDot(1), _buildDot(2)],
                  ),
                ),
              ),
            ),

          // Quick suggestions
          if (aiService.messages.length <= 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AiQuickSuggestions(
                suggestions: AIAssistantService.quickSuggestions,
                onTap: (text) {
                  _textController.text = text;
                  _sendMessage(text);
                  _textController.clear();
                },
              ),
            ),

          // Input bar
          _buildInputBar(aiService),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 1.0),
        duration: Duration(milliseconds: 600 + index * 200),
        builder: (context, value, child) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: value),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(AIAssistantService aiService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Image picker button
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.photo_camera_rounded,
                  color: AppColors.textSecondary,
                ),
                onPressed: _pickImage,
                tooltip: 'Attach photo',
              ),
            ),
            const SizedBox(width: 8),

            // Text field
            Expanded(
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Describe your problem...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => _textController.clear(),
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _sendMessage(value.trim());
                    _textController.clear();
                  }
                },
                maxLines: 4,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),

            // Send button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _textController.text.trim().isEmpty
                    ? null
                    : () {
                        _sendMessage(_textController.text.trim());
                        _textController.clear();
                      },
                disabledColor: Colors.white38,
                tooltip: 'Send',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
