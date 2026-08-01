import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../app/providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String professionalId;

  const BookingScreen({super.key, required this.professionalId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  String _selectedLocation = 'Kathmandu, Nepal';
  double _estimatedHours = 2.0;
  double _totalPrice = 0.0;
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final professional = ref
          .read(professionalServiceProvider)
          .getProfessionalById(widget.professionalId);
      if (professional != null) {
        setState(() {
          _totalPrice = professional.hourlyRate * _estimatedHours;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _book() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final bookingService = ref.read(bookingServiceProvider);
    final professional = ref
        .read(professionalServiceProvider)
        .getProfessionalById(widget.professionalId);

    if (professional != null) {
      await bookingService.createBooking(
        professionalId: widget.professionalId,
        professionalName: professional.name,
        professionalPhotoUrl: professional.photoUrl ?? '',
        serviceCategory: professional.category,
        serviceDescription: _descriptionController.text,
        location: _selectedLocation,
        scheduledDate: _selectedDate,
        scheduledTime: _selectedTime,
        price: _totalPrice,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        AppUtils.showSnackBar(context, 'Booking created successfully!');
        context.go('/bookings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final professional = ref
        .watch(professionalServiceProvider)
        .getProfessionalById(widget.professionalId);

    // Guest guard
    if (authService.guardAction(context, AppConstants.actionBook)) {
      return const SizedBox.shrink();
    }

    if (professional == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Service')),
        body: const Center(child: Text('Professional not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Professional Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: professional.isVerified
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            )
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        professional.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                professional.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (professional.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          professional.category,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppUtils.formatCurrency(professional.hourlyRate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        '/hr',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Label
            const _SectionLabel(
              icon: Icons.description_rounded,
              title: 'Service Description',
              required: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe the service you need...',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please describe the service' : null,
            ),

            const SizedBox(height: 24),

            // Date & Time
            const _SectionLabel(
              icon: Icons.calendar_month_rounded,
              title: 'Schedule',
              required: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ScheduleField(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: AppUtils.formatDate(_selectedDate),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ScheduleField(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _selectedTime,
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (context) => _TimeSlotPicker(
                          slots: _timeSlots,
                          selected: _selectedTime,
                        ),
                      );
                      if (selected != null) {
                        setState(() => _selectedTime = selected);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Location
            const _SectionLabel(
              icon: Icons.location_on_rounded,
              title: 'Location',
              required: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _selectedLocation,
              decoration: const InputDecoration(
                hintText: 'Enter your location',
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
              onChanged: (v) => _selectedLocation = v,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please enter location' : null,
            ),

            const SizedBox(height: 24),

            // Estimated Hours
            const _SectionLabel(
              icon: Icons.timelapse_rounded,
              title: 'Estimated Duration',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                children: [
                  Slider(
                    value: _estimatedHours,
                    min: 0.5,
                    max: 8,
                    divisions: 15,
                    label: '${_estimatedHours.toStringAsFixed(1)} hrs',
                    onChanged: (v) {
                      setState(() {
                        _estimatedHours = v;
                        _totalPrice = professional.hourlyRate * v;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_estimatedHours.toStringAsFixed(1)} hrs',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${AppUtils.formatCurrency(professional.hourlyRate)}/hr',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Price Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Base Rate',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '${AppUtils.formatCurrency(professional.hourlyRate)}/hr',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Duration',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '${_estimatedHours.toStringAsFixed(1)} hrs',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.white24, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        AppUtils.formatCurrency(_totalPrice),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            const _SectionLabel(
              icon: Icons.notes_rounded,
              title: 'Additional Notes',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Any special instructions...',
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
          child: ElevatedButton(
            onPressed: _isLoading ? null : _book,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Confirm Booking'),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool required;

  const _SectionLabel({
    required this.icon,
    required this.title,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$title${required ? ' *' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}

class _ScheduleField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ScheduleField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSlotPicker extends StatelessWidget {
  final List<String> slots;
  final String selected;

  const _TimeSlotPicker({required this.slots, required this.selected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final isSelected = slot == selected;
                return GestureDetector(
                  onTap: () => Navigator.pop(context, slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: AppColors.primaryGradient,
                            )
                          : null,
                      color: isSelected ? null : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
