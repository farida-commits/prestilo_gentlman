// features/onboarding/presentation/pages/onboarding_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/onboarding_progress_indicator.dart';
import '../widgets/rating_dialog.dart';
import 'paywall_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingPageData {
  final String background;
  final String title;

  const _OnboardingPageData({required this.background, required this.title});
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _ratingTimer;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      background: 'assets/images/0_1_3.png',
      title: 'Every suit. Every detail.\nPerfectly tracked',
    ),
    _OnboardingPageData(
      background: 'assets/images/0_1_4.png',
      title: 'Track, manage, and\nelevate your wardrobe',
    ),
    _OnboardingPageData(
      background: 'assets/images/0_1_5.png',
      title: 'Keep your suits\nflawless. Always',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ratingTimer = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const RatingDialog(),
      );
    });
  }

  @override
  void dispose() {
    _ratingTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaywallScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141927),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Image.asset(
                page.background,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Positioned(
            left: 48,
            right: 48,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OnboardingProgressIndicator(
                  totalPages: _pages.length,
                  currentPage: _currentPage,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff141927),
                    borderRadius: BorderRadius.circular(20),
                  ),                  
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [                      
                      const SizedBox(height: 16),
                      Text(
                        _pages[_currentPage].title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title21,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Continue', 
                            style: AppTextStyles.body16
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}