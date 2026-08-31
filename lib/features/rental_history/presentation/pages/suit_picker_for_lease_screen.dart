// features/rental_history/presentation/pages/suit_picker_for_lease_screen.dart
// ("+" же "Create new rental" басканда — арендага даяр суйттарды тандоо)
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../suits/data/datasources/suit_local_datasource.dart';
import '../../../suits/domain/entities/suit_entity.dart';
import '../../../suits/presentation/widgets/suit_card.dart';
import '../../../suits/presentation/pages/suit_detail_screen.dart';

class SuitPickerForLeaseScreen extends StatefulWidget {
  const SuitPickerForLeaseScreen({super.key});

  @override
  State<SuitPickerForLeaseScreen> createState() => _SuitPickerForLeaseScreenState();
}

class _SuitPickerForLeaseScreenState extends State<SuitPickerForLeaseScreen> {
  final SuitLocalDataSource _dataSource = SuitLocalDataSource();
  List<SuitEntity> _suits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await _dataSource.getAllSuits();
    setState(() {
      _suits = all.where((s) => s.status == SuitStatus.inStock).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Select a suit', style: AppTextStyles.suits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _suits.length,
                      itemBuilder: (context, index) {
                        final suit = _suits[index];
                        return SuitCard(
                          suit: suit,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SuitDetailScreen(
                                  suit: suit,
                                  onUpdate: (_) {},
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}