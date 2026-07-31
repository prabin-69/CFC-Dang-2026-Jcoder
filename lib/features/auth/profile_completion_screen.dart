import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../services/auth_service.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skillController = TextEditingController();
  String _selectedRole = AppConstants.roleCustomer;
  String? _selectedLocation;
  String? _experience;
  final List<String> _skills = [];
  int _currentStep = 0;

  final List<String> _locations = [
    'Kathmandu, Nepal',
    'Patan, Nepal',
    'Bhaktapur, Nepal',
    'Pokhara, Nepal',
    'Lalitpur, Nepal',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    await authService.updateProfile(
      name: _nameController.text.trim(),
      location: _selectedLocation,
      role: _selectedRole,
      skills: _selectedRole == AppConstants.roleProfessional ? _skills : null,
    );

    if (mounted) {
      AppUtils.showSnackBar(context, 'Welcome to WorkLink!');
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        leading: const SizedBox(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tell us about yourself to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Stepper
            Row(
              children: [
                _StepIndicator(
                  number: 1,
                  label: 'Basic',
                  isActive: _currentStep >= 0,
                  isCompleted: _currentStep > 0,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: _currentStep > 0
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                _StepIndicator(
                  number: 2,
                  label: 'Role',
                  isActive: _currentStep >= 1,
                  isCompleted: _currentStep > 1,
                ),
                if (_selectedRole == AppConstants.roleProfessional) ...[
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 1
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  _StepIndicator(
                    number: 3,
                    label: 'Skills',
                    isActive: _currentStep >= 2,
                    isCompleted: _currentStep > 2,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Step 1: Basic Info
            if (_currentStep == 0) ...[
              const Text(
                'Full Name *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),

              const SizedBox(height: 20),

              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: _locations
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedLocation = v),
                decoration: const InputDecoration(
                  hintText: 'Select your location',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) {
                      AppUtils.showSnackBar(
                        context,
                        'Please enter your name',
                        isError: true,
                      );
                      return;
                    }
                    setState(() => _currentStep = 1);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 48),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],

            // Step 2: Role Selection
            if (_currentStep == 1) ...[
              const Text(
                'I want to use WorkLink as a',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              _RoleCard(
                icon: Icons.person_rounded,
                title: 'Customer',
                subtitle: 'Hire professionals for services',
                isSelected: _selectedRole == AppConstants.roleCustomer,
                onTap: () =>
                    setState(() => _selectedRole = AppConstants.roleCustomer),
              ),
              const SizedBox(height: 12),
              _RoleCard(
                icon: Icons.build_rounded,
                title: 'Professional',
                subtitle: 'Offer your skills and get hired',
                isSelected: _selectedRole == AppConstants.roleProfessional,
                onTap: () => setState(
                  () => _selectedRole = AppConstants.roleProfessional,
                ),
              ),
              const SizedBox(height: 12),
              _RoleCard(
                icon: Icons.business_rounded,
                title: 'Business',
                subtitle: 'Manage a team of professionals',
                isSelected: _selectedRole == AppConstants.roleBusiness,
                onTap: () =>
                    setState(() => _selectedRole = AppConstants.roleBusiness),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep = 0),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedRole == AppConstants.roleProfessional) {
                          setState(() => _currentStep = 2);
                        } else {
                          _completeProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        _selectedRole == AppConstants.roleProfessional
                            ? 'Next'
                            : 'Complete',
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Step 3: Skills (Professional only)
            if (_currentStep == 2) ...[
              const Text(
                'Your Skills',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add skills you can offer',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Plumbing, Wiring',
                        prefixIcon: Icon(Icons.handyman_rounded),
                      ),
                      onFieldSubmitted: (v) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      onPressed: _addSkill,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Skills List
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => _skills.remove(s)),
                      ),
                    )
                    .toList(),
              ),

              if (_skills.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No skills added yet. Type a skill and tap +',
                      style: TextStyle(
                        color: AppColors.textHint.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                'Experience',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _experience,
                items:
                    [
                          'Less than 1 year',
                          '1-2 years',
                          '3-5 years',
                          '5-10 years',
                          '10+ years',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => _experience = v),
                decoration: const InputDecoration(
                  hintText: 'Select experience',
                  prefixIcon: Icon(Icons.timer_rounded),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep = 1),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _skills.isEmpty ? null : _completeProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() => _skills.add(skill));
      _skillController.clear();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.success
                : isActive
                ? AppColors.primary
                : AppColors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textHint,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.primary : AppColors.textHint,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
