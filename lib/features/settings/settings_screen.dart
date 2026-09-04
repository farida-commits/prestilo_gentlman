import 'package:flutter/material.dart';
import 'package:gentleman/features/rental_history/presentation/pages/rental_history_main_screen.dart';
import 'package:gentleman/features/statistics/presentation/pages/statistics_main_screen.dart';
import 'package:gentleman/features/suits/presentation/pages/suits_main_screen.dart';
import 'package:gentleman/features/suits/presentation/widgets/suits_bottom_nav.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Map<String, String>> _items = [
    {'label': 'Restore purchases', 'icon': 'assets/images/Restore purchases.png'},
    {'label': 'Privacy Policy', 'icon': 'assets/images/Privacy Policy.png'},
    {'label': 'Terms of Use', 'icon': 'assets/images/Terms of Use.png'},
    {'label': 'Support', 'icon': 'assets/images/Support.png'},
    {'label': 'Share', 'icon': 'assets/images/Share.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/fon.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  height: 52,
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.bmain,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text('Settings', style: AppTextStyles.headline28),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    children: _items
                        .map((item) => _SettingsTile(
                              label: item['label']!,
                              iconPath: item['icon']!,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SuitsBottomNav(
              currentIndex: 3,
              onTap: (index) {
                if (index == 3) return;
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SuitsMainScreen()));
                    break;
                  case 1:
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RentalHistoryMainScreen()));
                    break;
                  case 2:
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatisticsMainScreen()));
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final String iconPath;

  const _SettingsTile({required this.label, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: AppColors.bmain,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent, width: 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.headline28),
          Image.asset(iconPath, width: 36, height: 36),
        ],
      ),
    );
  }
}