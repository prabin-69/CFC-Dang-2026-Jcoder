import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../services/booking_service.dart';

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({super.key});

  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Plumbing';
  String? _preferredDate;
  String _budgetRange = '';
  String? _location;
  List<String> _imageUrls = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Painting',
    'Appliance Repair',
    'Gardening',
    'Other',
  ];

  final List<String> _budgetRanges = [
    'Under Rs. 1,000',
    'Rs. 1,000 - 3,000',
    'Rs. 3,000 - 5,000',
    'Rs. 5,000 - 10,000',
    'Rs. 10,000 - 20,000',
    'Rs. 20,000+',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageUrls.add(image.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final bookingService = context.read<BookingService>();
    await bookingService.createServiceRequest(
      category: _selectedCategory,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _location,
      preferredDate: _preferredDate,
      budgetRange: _budgetRange,
      imageUrls: _imageUrls.isNotEmpty ? _imageUrls : null,
    );

    if (mounted) {
      AppUtils.showSnackBar(context, 'Service request created successfully!');
      context.go('/bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Describe Your Problem')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.secondaryLight,
                    AppColors.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.secondary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Describe your problem and nearby professionals will send you quotations!',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryDark.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Category
            const Text(
              'Category *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedCategory = v ?? _selectedCategory),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_rounded),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Title *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g., Kitchen sink leaking',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please enter a title' : null,
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe your problem in detail...',
              ),
              validator: (v) => v == null || v.isEmpty
                  ? 'Please describe your problem'
                  : null,
            ),

            const SizedBox(height: 20),

            // Photos
            const Text(
              'Photos (Optional)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ..._imageUrls.map(
                  (url) => Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(url),
                        fit: BoxFit.cover,
                      ),
                      color: AppColors.surfaceVariant,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _imageUrls.remove(url)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Location
            const Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Your location',
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
              onChanged: (v) => _location = v,
            ),

            const SizedBox(height: 20),

            // Preferred Date
            const Text(
              'Preferred Date',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _preferredDate,
              items: [
                'Today',
                'Tomorrow',
                'This week',
                'Next week',
                'Flexible',
              ].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _preferredDate = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
            ),

            const SizedBox(height: 20),

            // Budget
            const Text(
              'Budget Range',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _budgetRange.isEmpty ? null : _budgetRange,
              items: _budgetRanges
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _budgetRange = v ?? ''),
              decoration: const InputDecoration(
                hintText: 'Select budget range',
                prefixIcon: Icon(Icons.monetization_on_rounded),
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
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Submit Request & Get Quotes'),
          ),
        ),
      ),
    );
  }
}
