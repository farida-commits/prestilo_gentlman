// features/rental_history/presentation/pages/suit_picker_for_lease_screen.dart
// ("+" же "Create new rental" басканда — арендага даяр суйттарды тандоо)
import 'package:flutter/material.dart';
import 'package:gentleman/features/clients/presentation/pages/clients_screen.dart';
import 'package:gentleman/features/clients/presentation/widgets/lease_result.dart';
import 'package:gentleman/features/rental_history/data/datasources/rental_local_datasource.dart';
import 'package:gentleman/features/rental_history/domain/entities/rental_record_entity.dart';
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
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();
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

    String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }

    Future<void> _onSuitSelected(SuitEntity suit) async {
    final result = await Navigator.push<LeaseResult>(
      context,
      MaterialPageRoute(builder: (_) => const ClientsScreen()),
    );

    if (result == null || !mounted) return;

    final record = RentalRecordEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      suitId: suit.id,
      suitName: suit.name,
      suitImagePath: suit.imagePath,
      suitBrand: suit.brand,
      suitPrice: suit.price,
      suitFabric: suit.fabric,
      suitSize: suit.size,
      clientId: result.client.id,
      clientName: result.client.name,
      rentalDate: _formatDate(result.endDate),
      profit: suit.price,
    );

    await _rentalDataSource.addRecord(record);

      final updatedSuit = suit.copyWith(
      status: SuitStatus.leased,
      dateLabel: _formatDate(result.endDate),
      currentClientId: result.client.id,
      currentClientName: result.client.name,
    );
    await _dataSource.saveSuit(updatedSuit);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/fon2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.bmain,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Image.asset(
                          'assets/images/around.png',
                          width: 30,
                          height: 30,
                        )
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bmain,
                          borderRadius: BorderRadius.circular(9),
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
                            onTap: () => _onSuitSelected(suit),
                          );
                        },
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