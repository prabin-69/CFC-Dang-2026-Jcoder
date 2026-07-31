import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../services/professional_service.dart';
import '../../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final String professionalId;

  const BookingScreen({super.key, required this.professionalId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
    final professional = context
        .read<ProfessionalService>()
        .getProfessionalById(widget.professionalId);
    if (professional != null) {
      _totalPrice = professional.hourlyRate * _estimatedHours;
    }
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

    final bookingService = context.read<BookingService>();
    final professional = context
        .read<ProfessionalService>()
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
    final professional = context
        .watch<ProfessionalService>()
        .getProfessionalById(widget.professionalId);

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
            // Professional Info
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    professional.name[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                title: Text(
                  professional.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(professional.category),
                trailing: Text(
                  AppUtils.formatCurrency(professional.hourlyRate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Service Description
            const Text(
              'Service Description *',
              style: TextStyle(fontWeight: FontWeight.w600),
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date *',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 90),
                            ),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(width: 8),
                              Text(AppUtils.formatDate(_selectedDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time *',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedTime,
                        items: _timeSlots
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedTime = v ?? _selectedTime),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.access_time_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Location
            const Text(
              'Location *',
              style: TextStyle(fontWeight: FontWeight.w600),
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
            const Text(
              'Estimated Hours',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Duration: '),
                Expanded(
                  child: Slider(
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
                ),
                Text('${_estimatedHours.toStringAsFixed(1)} hrs'),
              ],
            ),

            const SizedBox(height: 16),

            // Price Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppUtils.formatCurrency(_totalPrice),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            const Text(
              'Additional Notes',
              style: TextStyle(fontWeight: FontWeight.w600),
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
              color: Colors.black.withOpacity(0.05),
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
