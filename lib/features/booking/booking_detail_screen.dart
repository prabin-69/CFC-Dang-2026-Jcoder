import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../services/booking_service.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final bookingService = context.watch<BookingService>();
    final booking = bookingService.getBookingById(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Detail')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Detail')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppUtils.getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  AppUtils.getStatusIcon(booking.status),
                  color: AppUtils.getStatusColor(booking.status),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.statusLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppUtils.getStatusColor(booking.status),
                        ),
                      ),
                      Text(
                        'Booking #${booking.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Professional Info
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  booking.professionalName[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              title: Text(
                booking.professionalName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(booking.serviceCategory),
              trailing: Text(
                AppUtils.formatCurrency(booking.price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Service Details
          const Text(
            'Service Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _DetailRow(label: 'Description', value: booking.serviceDescription),
          _DetailRow(
            label: 'Location',
            value: booking.location ?? 'Not specified',
          ),
          _DetailRow(
            label: 'Date',
            value: AppUtils.formatDate(booking.scheduledDate),
          ),
          _DetailRow(
            label: 'Time',
            value: booking.scheduledTime ?? 'Not specified',
          ),
          if (booking.estimatedDuration != null)
            _DetailRow(
              label: 'Duration',
              value: '${booking.estimatedDuration!.toStringAsFixed(1)} hours',
            ),
          if (booking.notes != null)
            _DetailRow(label: 'Notes', value: booking.notes!),

          const SizedBox(height: 24),

          // Price Breakdown
          const Text(
            'Price Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service Fee'),
                    Text(AppUtils.formatCurrency(booking.price)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      AppUtils.formatCurrency(booking.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Actions
          if (booking.status == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: () {
                      bookingService.updateBookingStatus(
                        booking.id,
                        'cancelled',
                      );
                      AppUtils.showSnackBar(context, 'Booking cancelled');
                    },
                    child: const Text('Cancel Booking'),
                  ),
                ),
              ],
            ),
          ],

          if (booking.status == 'confirmed') ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go('/chat/chat${booking.professionalId}'),
                    child: const Text('Message Professional'),
                  ),
                ),
              ],
            ),
          ],

          if (booking.status == 'completed') ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.success,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service Completed!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thank you for using WorkLink. We hope you enjoyed the service.',
                          style: TextStyle(
                            color: AppColors.success.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textHint),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
