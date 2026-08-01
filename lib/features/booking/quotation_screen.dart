import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../app/providers.dart';
import '../../services/booking_service.dart';
import '../../models/service_request_model.dart';

class QuotationScreen extends ConsumerWidget {
  final String requestId;

  const QuotationScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingService = ref.watch(bookingServiceProvider);
    final request = bookingService.getServiceRequestById(requestId);
    final quotations = bookingService.getQuotationsForRequest(requestId);

    if (request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quotations')),
        body: const Center(child: Text('Request not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quotations')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Request Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.description,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Tag(label: request.category, color: AppColors.primary),
                      if (request.budgetRange != null) ...[
                        const SizedBox(width: 8),
                        _Tag(
                          label: request.budgetRange!,
                          color: AppColors.secondary,
                        ),
                      ],
                      const Spacer(),
                      Text(
                        '${quotations.length} quotes',
                        style: const TextStyle(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (quotations.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: const Column(
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Waiting for quotations...',
                    style: TextStyle(fontSize: 16, color: AppColors.textHint),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              '${quotations.length} Quotation${quotations.length > 1 ? 's' : ''} Received',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...quotations.map(
              (q) => _buildQuotationCard(context, q, bookingService),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuotationCard(
    BuildContext context,
    QuotationModel quotation,
    BookingService bookingService,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    quotation.professionalName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotation.professionalName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Sent ${AppUtils.timeAgo(quotation.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppUtils.formatCurrency(quotation.price),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (quotation.description != null) ...[
              const SizedBox(height: 12),
              Text(
                quotation.description!,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
            if (quotation.estimatedDuration != null ||
                quotation.timeline != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (quotation.estimatedDuration != null)
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      label: quotation.estimatedDuration!,
                    ),
                  if (quotation.timeline != null) ...[
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.calendar_today_outlined,
                      label: quotation.timeline!,
                    ),
                  ],
                ],
              ),
            ],
            if (quotation.status == 'pending') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: () {
                    bookingService.acceptQuotation(quotation.id, requestId);
                    AppUtils.showSnackBar(context, 'Quotation accepted!');
                  },
                  child: Text(
                    'Accept Quotation - ${AppUtils.formatCurrency(quotation.price)}',
                  ),
                ),
              ),
            ] else if (quotation.status == 'accepted') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Accepted',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
