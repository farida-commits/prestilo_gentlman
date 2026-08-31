// features/rental_history/presentation/pages/rental_history_main_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../suits/data/datasources/suit_local_datasource.dart';
import '../../../suits/presentation/widgets/suits_bottom_nav.dart';
import '../../../clients/data/datasources/client_local_datasource.dart';
import '../../../clients/presentation/pages/clients_list_screen.dart';
import '../../data/datasources/rental_local_datasource.dart';
import '../../domain/entities/rental_record_entity.dart';
import '../widgets/suit_history_card.dart';
import '../widgets/client_history_card.dart';
import 'suit_picker_for_lease_screen.dart';

enum HistoryTab { bySuits, byClients }

class RentalHistoryMainScreen extends StatefulWidget {
  const RentalHistoryMainScreen({super.key});

  @override
  State<RentalHistoryMainScreen> createState() => _RentalHistoryMainScreenState();
}

class _RentalHistoryMainScreenState extends State<RentalHistoryMainScreen> {
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();
  final SuitLocalDataSource _suitDataSource = SuitLocalDataSource();
  final ClientLocalDataSource _clientDataSource = ClientLocalDataSource();

  List<RentalRecordEntity> _records = [];
  bool _hasAnySuit = false;
  bool _isLoading = true;
  HistoryTab _tab = HistoryTab.bySuits;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await _rentalDataSource.getAllRecords();
    final suits = await _suitDataSource.getAllSuits();
    setState(() {
      _records = records;
      _hasAnySuit = suits.isNotEmpty;
      _isLoading = false;
    });
  }

  List<SuitHistoryStats> get _suitStats {
    final Map<String, List<RentalRecordEntity>> grouped = {};
    for (final r in _records) {
      grouped.putIfAbsent(r.suitId, () => []).add(r);
    }
    return grouped.entries.map((entry) {
      final list = entry.value;
      final last = list.last;
      double total = 0;
      for (final r in list) {
        total += double.tryParse(r.profit) ?? 0;
      }
      return SuitHistoryStats(
        suitId: entry.key,
        suitName: last.suitName,
        suitImagePath: last.suitImagePath,
        totalProfit: total.toStringAsFixed(0),
        leaseCount: list.length,
        lastRentalDate: last.rentalDate,
        lastCustomer: last.clientName,
      );
    }).toList();
  }

  List<ClientHistoryStats> get _clientStats {
    final Map<String, List<RentalRecordEntity>> grouped = {};
    for (final r in _records) {
      grouped.putIfAbsent(r.clientId, () => []).add(r);
    }
    return grouped.entries.map((entry) {
      final list = entry.value;
      final last = list.last;
      double total = 0;
      for (final r in list) {
        total += double.tryParse(r.profit) ?? 0;
      }
      return ClientHistoryStats(
        clientId: entry.key,
        clientName: last.clientName,
        clientPhotoPath: null,
        totalIncome: total.toStringAsFixed(0),
        rentalCount: list.length,
        lastSuit: last.suitName,
        lastRentalDate: last.rentalDate,
      );
    }).toList();
  }

  Future<void> _onCreateRental() async {
    if (!_hasAnySuit) {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No suit', style: AppTextStyles.headline28),
                const SizedBox(height: 8),
                Text(
                  'Add your first costume for easy\nstorage of them',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption12.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SuitPickerForLeaseScreen()),
    );
    _load();
  }

  Future<void> _openClientsList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClientsListScreen()),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final bool isEmpty = _records.isEmpty;

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      if (!isEmpty) ...[
                        GestureDetector(
                          onTap: _openClientsList,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.person_outline, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Rental history', style: AppTextStyles.suits),
                        ),
                      ),
                      if (!isEmpty) ...[
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _onCreateRental,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _tabButton('By Suits', HistoryTab.bySuits),
                        const SizedBox(width: 20),
                        _tabButton('By Clients', HistoryTab.byClients),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: _tab == HistoryTab.bySuits
                              ? _suitStats.map((s) => SuitHistoryCard(stats: s)).toList()
                              : _clientStats.map((c) => ClientHistoryCard(stats: c)).toList(),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: SuitsBottomNav(currentIndex: 1, onTap: (_) {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, HistoryTab value) {
    final bool isActive = _tab == value;
    return GestureDetector(
      onTap: () => setState(() => _tab = value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.accent : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(height: 2, width: 20, color: AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.navy.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No History', style: AppTextStyles.headline28),
            const SizedBox(height: 8),
            Text(
              "Rent out your costumes and\nthere'll be a story here.",
              textAlign: TextAlign.center,
              style: AppTextStyles.caption12.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onCreateRental,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Create new rental', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}