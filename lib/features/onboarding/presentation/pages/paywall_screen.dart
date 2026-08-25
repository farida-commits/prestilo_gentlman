// features/onboarding/presentation/pages/paywall_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/0_1_6.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 56,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Restore Purchase', 
                        style: AppTextStyles.title22
                        
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.close, 
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 155,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              decoration: BoxDecoration(
                color: AppColors.bmain,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Get premium', 
                    style: AppTextStyles.headline52,
                  ),
                  const SizedBox(height: 16),
                  const _PaywallFeature(
                    text: 'Keep your costumes handy',
                    
                  ),
                  Divider(color: Color(0xff454954), height: 24),
                  const _PaywallFeature(text: 'Add unlimited costumes'),
                  Divider(color: Color(0xff454954), height: 24),
                  const _PaywallFeature(text: 'Stats for the whole time'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 95,
            left: 25,
            right: 25,
            child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        'Update to premium for \$0.99',
                        style: AppTextStyles.body16,
                      ),
                    ),
                  ),
          ),
          Positioned(
            bottom: 44,
            left: 25,
            right: 25,
            child:  Row(
                    children: [
                      Expanded(
                        child: _PaywallOutlinedButton(
                          text: 'Terms of use', onTap: () {}),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PaywallOutlinedButton(
                          text: 'Privacy Policy', 
                          onTap: () {},
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

class _PaywallFeature extends StatelessWidget {
  final String text;
  const _PaywallFeature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.body16,
    );
  }
}

class _PaywallOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PaywallOutlinedButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTextStyles.captionBold12.copyWith(
            color: AppColors.bmain,  
          )
        ),
      ),
    );
  }
}