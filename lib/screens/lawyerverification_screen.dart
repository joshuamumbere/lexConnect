import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class LawyerVerificationScreen extends StatefulWidget {
  const LawyerVerificationScreen({Key? key}) : super(key: key);

  @override
  _LawyerVerificationScreenState createState() =>
      _LawyerVerificationScreenState();
}

class _LawyerVerificationScreenState extends State<LawyerVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final TextEditingController _expirationDateController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Verification state
  int _currentStep = 0;
  XFile? _licenseFrontImage;
  XFile? _licenseBackImage;
  XFile? _profileImage;
  List<String> _selectedSpecialties = [];
  bool _isSubmitting = false;
  bool _termsAccepted = false;

  // Legal specialties
  final List<String> _legalSpecialties = [
    'Tax Law',
    'Immigration Law',
    'Corporate Law',
    'Family Law',
    'Property Law',
    'Criminal Law',
    'Intellectual Property',
    'Employment Law',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Verify Your Credentials'),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verification Progress
                    _buildVerificationProgress(),
                    const SizedBox(height: 32),

                    // Step Content
                    IndexedStack(
                      index: _currentStep,
                      children: [
                        // Step 1: License Upload
                        _buildLicenseUploadStep(),

                        // Step 2: Specialties Selection
                        _buildSpecialtiesStep(),

                        // Step 3: Profile Setup
                        _buildProfileStep(),

                        // Step 4: Review & Submit
                        _buildReviewStep(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Navigation Buttons
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    index <= _currentStep
                        ? const Color(0xFF2E5BFF)
                        : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color:
                        index <= _currentStep
                            ? Colors.white
                            : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _getStepTitle(_currentStep),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Upload License';
      case 1:
        return 'Select Specialties';
      case 2:
        return 'Profile Setup';
      case 3:
        return 'Review & Submit';
      default:
        return '';
    }
  }

  Widget _buildLicenseUploadStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bar License Verification',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload clear photos of your bar license to verify your credentials',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Front of License
          _buildUploadCard(
            title: 'Front of License',
            image: _licenseFrontImage,
            onTap: () => _pickImage(true),
          ),
          const SizedBox(height: 16),

          // Back of License
          _buildUploadCard(
            title: 'Back of License',
            image: _licenseBackImage,
            onTap: () => _pickImage(false),
          ),
          const SizedBox(height: 16),

          // License Number
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Bar License Number',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your license number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Expiration Date
          TextFormField(
            controller: _expirationDateController,
            decoration: InputDecoration(
              labelText: 'Expiration Date',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () => _selectDate(context),
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select expiration date';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Legal Specialties',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select at least one area of practice (max 3)',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // Specialty Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _legalSpecialties.map((specialty) {
                final isSelected = _selectedSpecialties.contains(specialty);
                return FilterChip(
                  label: Text(specialty),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (_selectedSpecialties.length < 3) {
                          _selectedSpecialties.add(specialty);
                        }
                      } else {
                        _selectedSpecialties.remove(specialty);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF2E5BFF).withOpacity(0.2),
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? const Color(0xFF2E5BFF)
                            : Colors.grey.shade800,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          isSelected
                              ? const Color(0xFF2E5BFF)
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Professional Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete your public profile for clients',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // Profile Photo
        Center(
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  image:
                      _profileImage != null
                          ? DecorationImage(
                            image: FileImage(File(_profileImage!.path)),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    _profileImage == null
                        ? const Icon(
                          Iconsax.profile_circle,
                          size: 48,
                          color: Colors.grey,
                        )
                        : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5BFF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () => _pickProfileImage(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Professional Details
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          decoration: InputDecoration(
            labelText: 'Law Firm (if applicable)',
            prefixIcon: const Icon(Icons.business_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          decoration: InputDecoration(
            labelText: 'Years of Practice',
            prefixIcon: const Icon(Icons.work_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Professional Bio',
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Please verify all details before submission',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // License Preview
        if (_licenseFrontImage != null)
          _buildReviewItem(
            icon: Icons.badge_outlined,
            title: 'Bar License',
            value: 'Front & Back uploaded',
          ),

        // Specialties
        if (_selectedSpecialties.isNotEmpty)
          _buildReviewItem(
            icon: Icons.workspace_premium_outlined,
            title: 'Specialties',
            value: _selectedSpecialties.join(', '),
          ),

        // Terms Checkbox
        Row(
          children: [
            Checkbox(
              value: _termsAccepted,
              onChanged: (value) {
                setState(() {
                  _termsAccepted = value ?? false;
                });
              },
              activeColor: const Color(0xFF2E5BFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text:
                      'I certify that all information provided is accurate and agree to the ',
                  style: TextStyle(color: Colors.grey.shade700),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: Color(0xFF2E5BFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5BFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF2E5BFF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.grey.shade600),
            onPressed: () => _navigateToStep(0), // Go back to relevant step
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onPressed: () {
                setState(() => _currentStep--);
              },
              child: const Text('BACK'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5BFF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              if (_currentStep < 3) {
                if (_validateCurrentStep()) {
                  setState(() => _currentStep++);
                }
              } else {
                _submitVerification();
              }
            },
            child: Text(
              _currentStep == 3 ? 'SUBMIT VERIFICATION' : 'CONTINUE',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                image != null ? const Color(0xFF2E5BFF) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(
              image != null ? Icons.check_circle : Icons.cloud_upload_outlined,
              size: 48,
              color:
                  image != null
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            if (image != null) ...[
              const SizedBox(height: 8),
              Text(
                'Uploaded: ${image.name}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(bool isFront) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          if (isFront) {
            _licenseFrontImage = image;
          } else {
            _licenseBackImage = image;
          }
        });
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.message}')),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _profileImage = image);
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.message}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E5BFF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Assuming you have a TextEditingController for the expiration date field
        _expirationDateController.text =
            '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState?.validate() ?? false;
      case 1:
        return _selectedSpecialties.isNotEmpty;
      default:
        return true;
    }
  }

  void _navigateToStep(int step) {
    setState(() => _currentStep = step);
  }

  Future<void> _submitVerification() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // TODO: Implement your verification API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      Navigator.pushReplacementNamed(context, '/verification-pending');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
