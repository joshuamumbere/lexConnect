import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Find Specialized Lawyers",
      description: "Connect with top-rated legal experts in 10+ practice areas",
      icon: Icons.people_alt_rounded,
      color: Color(0xFF2E5BFF),
      image: "assets/onboarding1.png",
    ),
    OnboardingPage(
      title: "Instant Video Consultations",
      description: "Get legal advice face-to-face without leaving home",
      icon: Icons.videocam_rounded,
      color: Color(0xFF8C54FF),
      image: "assets/onboarding2.png",
    ),
    OnboardingPage(
      title: "Secure Document Handling",
      description: "Upload and sign legal documents with bank-level security",
      icon: Icons.lock_rounded,
      color: Color(0xFF00C4FF),
      image: "assets/onboarding3.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
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
      body: Stack(
        children: [
          // Background Layer
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _pages[_currentPage].color.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    if (index == _pages.length - 1) {
                      _buttonController.forward();
                    } else {
                      _buttonController.reset();
                    }
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(page: _pages[index]);
                  },
                ),
              ),

              // Indicator and Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: _pages[_currentPage].color,
                        dotColor: Colors.grey.shade300,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 10,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Animated Get Started Button
                    if (_currentPage == _pages.length - 1)
                      ScaleTransition(
                        scale: _buttonAnimation,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 56),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/role-select',
                            );
                          },
                          child: Text(
                            "GET STARTED",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/role-select',
                              );
                            },
                            child: Text(
                              "SKIP",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: _pages[_currentPage].color,
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Image Placeholder
          Container(
            height: 250,
            margin: EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(page.image),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 40),

          // Icon with animated background
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 36, color: page.color),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.image,
  });
}
