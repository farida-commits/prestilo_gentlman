// features/clients/presentation/pages/client_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';
import '../../../rental_history/domain/entities/rental_record_entity.dart';
import '../../../rental_history/data/datasources/rental_local_datasource.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import '../widgets/suit_history_mini_card.dart';
import 'add_edit_client_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  final ClientEntity client;
  final VoidCallback? onDeleted;

  const ClientDetailScreen({super.key, required this.client, this.onDeleted});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();

  late ClientEntity _client;
  List<RentalRecordEntity> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final all = await _rentalDataSource.getAllRecords();
    setState(() {
      _records = all.where((r) => r.clientId == _client.id).toList();
      _isLoading = false;
    });
  }

  String get _favoriteSuit {
    if (_records.isEmpty) return '—';
    final counts = <String, int>{};
    for (final r in _records) {
      counts[r.suitName] = (counts[r.suitName] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  int get _rentalCount => _records.length;

  String get _totalIncome {
    double sum = 0;
    for (final r in _records) {
      sum += double.tryParse(r.profit) ?? 0;
    }
    return sum.toStringAsFixed(0);
  }

  String get _lastSuitTaken => _records.isEmpty ? '—' : _records.last.suitName;

  String get _lastRentalDate => _records.isEmpty ? '—' : _records.last.rentalDate;

  Future<void> _openEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditClientScreen(existingClient: _client)),
    );

    if (result == true) {
      widget.onDeleted?.call();
      if (mounted) Navigator.pop(context);
    } else if (result is ClientEntity) {
      setState(() => _client = result);
      _loadRecords();
    }
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
                      child: const Text('Your clients', style: AppTextStyles.suits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Container(
                          height: 39,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(_client.name, style: AppTextStyles.headline28),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _client.photoPath != null
                              ? SuitImageWidget(
                                  imagePath: _client.photoPath!,
                                  width: double.infinity,
                                  height: 295,
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 295,
                                  color: AppColors.navy,
                                  child: const Icon(Icons.person, color: Colors.white38, size: 64),
                                ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Customer's phone number", style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox(_client.phone),
                        const SizedBox(height: 16),
                        const Text("This client's favorite suit", style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox(_favoriteSuit),
                        const SizedBox(height: 16),
                        const Text('How many rentals did this client make', style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox('$_rentalCount'),
                        const SizedBox(height: 16),
                        const Text('Total income', style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox('\$$_totalIncome'),
                        const SizedBox(height: 16),
                        const Text('What was the last suit this user took', style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox(_lastSuitTaken),
                        const SizedBox(height: 16),
                        const Text('The last day a user rented a suit.', style: AppTextStyles.caption12),
                        const SizedBox(height: 6),
                        _fieldBox(_lastRentalDate),
                        const SizedBox(height: 20),
                        const Text('The last day a user rented a suit.', style: AppTextStyles.caption12),
                        const SizedBox(height: 8),
                        ..._records.map((r) => SuitHistoryMiniCard(record: r)),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _openEdit,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.accent, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Edit client card', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldBox(String value) {
    return Container(
      width: double.infinity,
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(value, style: AppTextStyles.body16),
    );
  }
}