import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ClientOnboardingScreen extends StatefulWidget {
  const ClientOnboardingScreen({Key? key}) : super(key: key);

  @override
  _ClientOnboardingScreenState createState() => _ClientOnboardingScreenState();
}

class _ClientOnboardingScreenState extends State<ClientOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  final _formKey = GlobalKey<FormState>();

  // Legal categories with icons
  final List<Map<String, dynamic>> _legalCategories = [
    {
      'name': 'Tax Law',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFF2E5BFF),
    },
    {
      'name': 'Immigration',
      'icon': Icons.airplanemode_active_rounded,
      'color': const Color(0xFF00C4FF),
    },
    {
      'name': 'Corporate',
      'icon': Icons.business_rounded,
      'color': const Color(0xFF8C54FF),
    },
    {
      'name': 'Family Law',
      'icon': Icons.family_restroom_rounded,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Property',
      'icon': Icons.home_work_rounded,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Criminal',
      'icon': Icons.gavel_rounded,
      'color': const Color(0xFFF44336),
    },
  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _buttonAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Step 1: Legal Need Selection
              _buildLegalNeedStep(),

              // Step 2: Basic Information
              _buildPersonalInfoStep(),

              // Step 3: Location & Preferences
              _buildPreferencesStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalNeedStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          title: "What legal help do you need?",
          subtitle: "Select one or more categories",
          step: 1,
        ),
        const SizedBox(height: 32),

        // Legal Category Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _legalCategories.length,
            itemBuilder: (context, index) {
              final category = _legalCategories[index];
              return _LegalCategoryCard(
                icon: category['icon'],
                title: category['name'],
                color: category['color'],
                isSelected: _currentStep == index,
                onTap: () {
                  setState(() => _currentStep = index);
                },
              );
            },
          ),
        ),
        _buildNavigationButtons(showNext: true),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildStepHeader(
            title: "Tell us about yourself",
            subtitle: "We'll use this to match you with lawyers",
            step: 2,
          ),
          const SizedBox(height: 32),

          Expanded(
            child: ListView(
              children: [
                TextFormField(
                  decoration: _inputDecoration(
                    "Full Name",
                    Icons.person_outline,
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: _inputDecoration("Email", Icons.email_outlined),
                  validator:
                      (value) =>
                          !value!.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: _inputDecoration(
                    "Phone Number",
                    Icons.phone_outlined,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                Text(
                  "Briefly describe your legal need:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "E.g. 'Need help with visa application'",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _legalCategories[_currentStep]['color'],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildNavigationButtons(showNext: true, showBack: true),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          title: "Almost there!",
          subtitle: "Set your location and preferences",
          step: 3,
        ),
        const SizedBox(height: 32),

        Expanded(
          child: ListView(
            children: [
              _LocationPickerCard(
                color: _legalCategories[_currentStep]['color'],
                onTap: () => _showLocationPicker(context),
              ),
              const SizedBox(height: 24),
              Text(
                "Preferred communication:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCommunicationOptions(),
              const SizedBox(height: 24),
              _buildUrgencySelector(),
            ],
          ),
        ),
        _buildNavigationButtons(showSubmit: true, showBack: true),
      ],
    );
  }

  Widget _buildStepHeader({
    required String title,
    required String subtitle,
    required int step,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _legalCategories[_currentStep]['color'],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: _legalCategories[_currentStep]['color'],
                dotColor: Colors.grey.shade300,
                dotHeight: 6,
                dotWidth: 6,
                spacing: 8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons({
    bool showNext = false,
    bool showBack = false,
    bool showSubmit = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          if (showBack)
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
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  "BACK",
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (showBack) const SizedBox(width: 16),
          if (showNext)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _legalCategories[_currentStep]['color'],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (showSubmit)
            Expanded(
              child: ScaleTransition(
                scale: _buttonAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _legalCategories[_currentStep]['color'],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    _buttonController.forward();
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/client-dashboard',
                      );
                    }
                  },
                  child: const Text(
                    "FIND MY LAWYER",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _legalCategories[_currentStep]['color']),
      ),
    );
  }

  Widget _buildCommunicationOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ChipOption(
          label: "Video Call",
          icon: Icons.videocam_outlined,
          color: _legalCategories[_currentStep]['color'],
        ),
        _ChipOption(
          label: "Phone Call",
          icon: Icons.phone_outlined,
          color: _legalCategories[_currentStep]['color'],
        ),
        _ChipOption(
          label: "In-Person",
          icon: Icons.person_outline,
          color: _legalCategories[_currentStep]['color'],
        ),
        _ChipOption(
          label: "Chat",
          icon: Icons.chat_outlined,
          color: _legalCategories[_currentStep]['color'],
        ),
      ],
    );
  }

  Widget _buildUrgencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How urgent is your matter?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _UrgencyLevel(
                label: "Standard",
                level: 1,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _UrgencyLevel(
                label: "Urgent",
                level: 2,
                color: Colors.orange.shade200,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _UrgencyLevel(
                label: "Emergency",
                level: 3,
                color: Colors.red.shade200,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Your Location",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Search city or postcode",
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _LocationTile(
                      city: "New York",
                      country: "United States",
                      onTap: () {},
                    ),
                    _LocationTile(
                      city: "London",
                      country: "United Kingdom",
                      onTap: () {},
                    ),
                    _LocationTile(
                      city: "Toronto",
                      country: "Canada",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegalCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _LegalCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationPickerCard extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _LocationPickerCard({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on_outlined, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Select your city",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _ChipOption({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      labelStyle: TextStyle(color: color),
      avatar: Icon(icon, size: 18, color: color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      selectedColor: color.withOpacity(0.1),
      onSelected: (bool selected) {},
    );
  }
}

class _UrgencyLevel extends StatelessWidget {
  final String label;
  final int level;
  final Color color;

  const _UrgencyLevel({
    required this.label,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade800),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index < level ? color : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: color),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String city;
  final String country;
  final VoidCallback onTap;

  const _LocationTile({
    required this.city,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.location_on_outlined),
      title: Text(city),
      subtitle: Text(country),
      onTap: onTap,
    );
  }
}
