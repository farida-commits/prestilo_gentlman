// features/clients/presentation/pages/clients_list_screen.dart
// (Rental history'ден чакырылуучу башкаруу экраны — Select баскычы жок, тап -> деталь)
import 'package:flutter/material.dart';
import 'package:gentleman/features/rental_history/data/datasources/rental_local_datasource.dart';
import 'package:gentleman/features/rental_history/domain/entities/rental_record_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/client_local_datasource.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import '../widgets/client_card.dart';
import 'add_edit_client_screen.dart';
import 'client_detail_screen.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final ClientLocalDataSource _dataSource = ClientLocalDataSource();
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();

  List<ClientEntity> _clients = [];
  Map<String, List<RentalRecordEntity>> _recordsByClient = {};
  bool _isLoading = true;

  Future<void> _loadClients() async {
    final clients = await _dataSource.getAllClients();
    final records = await _rentalDataSource.getAllRecords(); // кошуу
    final grouped = <String, List<RentalRecordEntity>>{};
    for (final r in records) {
      grouped.putIfAbsent(r.clientId, () => []).add(r);
    }
    setState(() {
      _clients = clients;
      _recordsByClient = grouped;
      _isLoading = false;
    });
  }

   String? _favoriteSuitFor(String clientId) {
    final list = _recordsByClient[clientId];
    if (list == null || list.isEmpty) return null;
    final counts = <String, int>{};
    for (final r in list) {
      counts[r.suitName] = (counts[r.suitName] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Future<void> _openAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditClientScreen()),
    );
    _loadClients();
  }

  Future<void> _openDetail(ClientEntity client) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClientDetailScreen(client: client, onDeleted: _loadClients),
      ),
    );
    _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final bool isEmpty = _clients.isEmpty;

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
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _openAdd,
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
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('No clients', style: AppTextStyles.headline28),
                            const SizedBox(height: 8),
                            Text(
                              "You haven't added customers to\nselect them yet, fix that sooner\nrather than later",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption12.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _openAdd,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Create the first one', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _clients.length,
                      itemBuilder: (context, index) {
                        final client = _clients[index];
                        final loyalty = _recordsByClient[client.id]?.length ?? 0;
                        return ClientCard(
                          client: client,
                          isSelected: false,
                          onTap: () => _openDetail(client),
                          loyalty: loyalty,
                          favoriteSuit: _favoriteSuitFor(client.id),
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