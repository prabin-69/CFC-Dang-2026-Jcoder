import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../services/ai_service.dart';

class AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;
  final VoidCallback? onActionTap;
  final Function(AiActionType, String?)? onAction;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.onActionTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return _buildUserBubble(context);
    }
    return _buildAiBubble(context);
  }

  Widget _buildUserBubble(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16, top: 4, bottom: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              20,
            ).copyWith(bottomRight: Radius.zero),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiBubble(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60, left: 16, top: 4, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Name
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, AppColors.secondaryLight],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'WorkLink AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Message content
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  20,
                ).copyWith(bottomLeft: Radius.zero),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  // Recommended professionals
                  if (message.recommendedProfessionals != null &&
                      message.recommendedProfessionals!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...message.recommendedProfessionals!.map(
                      (pro) => _buildProfessionalChip(
                        context,
                        pro.name,
                        pro.category,
                        pro.rating,
                      ),
                    ),
                  ],

                  // Action buttons
                  if (message.actions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...message.actions.map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _buildActionButton(context, action),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalChip(
    BuildContext context,
    String name,
    String category,
    double rating,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, AiAction action) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (action.type) {
      case AiActionType.viewProfessionals:
        icon = Icons.people_rounded;
        color = AppColors.primary;
        bgColor = AppColors.primaryContainer;
        break;
      case AiActionType.createRequest:
        icon = Icons.add_circle_rounded;
        color = AppColors.secondary;
        bgColor = AppColors.secondaryContainer;
        break;
      case AiActionType.viewBookings:
        icon = Icons.book_online_rounded;
        color = AppColors.warning;
        bgColor = AppColors.warning.withOpacity(0.1);
        break;
      case AiActionType.none:
        icon = Icons.arrow_forward_rounded;
        color = AppColors.primary;
        bgColor = AppColors.primaryContainer;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => onAction?.call(action.type, action.payload),
        icon: Icon(icon, size: 18),
        label: Text(action.label, style: const TextStyle(fontSize: 13)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: bgColor,
          side: BorderSide(color: color.withOpacity(0.2)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
