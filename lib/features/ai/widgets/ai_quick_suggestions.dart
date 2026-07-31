import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AiQuickSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const AiQuickSuggestions({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(_iconFor(index), size: 14, color: AppColors.primary),
              label: Text(
                suggestion,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => onTap(suggestion),
              backgroundColor: AppColors.primaryContainer,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(int index) {
    switch (index % 5) {
      case 0:
        return Icons.plumbing_rounded;
      case 1:
        return Icons.air_rounded;
      case 2:
        return Icons.monetization_on_rounded;
      case 3:
        return Icons.people_rounded;
      case 4:
        return Icons.lightbulb_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
