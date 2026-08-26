// features/clients/presentation/pages/clients_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import '../widgets/client_card.dart';
import '../widgets/lease_date_picker_dialog.dart';
import '../widgets/lease_result.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final List<ClientEntity> _clients = const [
    ClientEntity(
      id: '1',
      name: 'James Carter',
      phone: '+1 (212) 555-0198',
      loyalty: 10,
      favoriteSuit: 'Black Tie Classic',
      imagePath: 'assets/images/client_1.jpg',
    ),
    ClientEntity(
      id: '2',
      name: 'Daniel Hughes',
      phone: '+1 (212) 222-0166',
      loyalty: 9,
      favoriteSuit: 'Royal Navy Suit',
      imagePath: 'assets/images/client_2.jpg',
    ),
    ClientEntity(
      id: '3',
      name: 'Oliver Bennett',
      phone: '+1 (212) 123-4318',
      loyalty: 10,
      favoriteSuit: 'Vintage Tails 1920',
      imagePath: 'assets/images/client_3.jpg',
    ),
  ];

  String? _selectedClientId;

  Future<void> _onSelectPressed() async {
    if (_selectedClientId == null) return;
    final client = _clients.firstWhere((c) => c.id == _selectedClientId);

    final result = await showDialog<LeaseResult>(
      context: context,
      builder: (_) => LeaseDatePickerDialog(client: client),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      // TODO: Add client screen
                    },
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
                          color: AppColors.navy.withOpacity(0.9),
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
                                onPressed: () {
                                  // TODO: Add client screen
                                },
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
                        return ClientCard(
                          client: client,
                          isSelected: _selectedClientId == client.id,
                          onTap: () => setState(() => _selectedClientId = client.id),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedClientId == null ? null : _onSelectPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: AppColors.accent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Select', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}