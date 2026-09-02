// features/clients/presentation/pages/clients_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/client_card.dart';
import '../widgets/lease_date_picker_dialog.dart';
import '../widgets/lease_result.dart';
import 'add_edit_client_screen.dart';
import '../../data/datasources/client_local_datasource.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientLocalDataSource _dataSource = ClientLocalDataSource();

  List<ClientEntity> _clients = [];
  bool _isLoading = true;
  String? _selectedClientId;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await _dataSource.getAllClients();
    setState(() {
      _clients = clients;
      _isLoading = false;
    });
  }

  Future<void> _openAddClient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditClientScreen()),
    );
    if (result != null) _loadClients();
  }

   void _onClientTap(String clientId) {
    setState(() {
      if (_selectedClientId == clientId) {
        // ошол эле клиентти кайра баскандай — тандоону жоготпойбуз, календарь ачык калат
        return;
      }
      _selectedClientId = clientId;
      _selectedDate = null; // жаңы клиент — дата кайра тандалышы керек
    });
  }

  void _onSelectPressed() {
    if (_selectedClientId == null || _selectedDate == null) return;
    final client = _clients.firstWhere((c) => c.id == _selectedClientId);
    final result = LeaseResult(
      client: client,
      startDate: DateTime.now(),
      endDate: _selectedDate!,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }
    final bool isEmpty = _clients.isEmpty;

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
                          ),
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
                          child: const Text(
                            'Your clients',
                            style: AppTextStyles.headline28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _openAddClient,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/plus.png',
                            width: 30,
                            height: 30,
                          ),
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
                            margin: const EdgeInsets.symmetric(horizontal: 35),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.bmain,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'No clients',
                                  style: AppTextStyles.headline52,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "You haven't added customers to\nselect them yet, fix that sooner\nrather than later",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body16.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _openAddClient,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                    ),
                                    child: Text(
                                      'Create the first one',
                                      style: AppTextStyles.body16,
                                    ),
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
                            // final bool isSelected =
                            //     _selectedClientId == client.id;
                            return ClientCard(
                              client: client,
                              isSelected: _selectedClientId == client.id,
                               onTap: () => _onClientTap(client.id),
                            );
                          },
                        ),
                ),
                SizedBox(height: 64,)
              ],
            ),
          ),
          if (_selectedClientId != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: LeaseDatePickerCalendar(
                      selectedDate: _selectedDate, 
                      onDateSelected: (date) => setState(() => _selectedDate = date),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 35,
            right: 35,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (_selectedClientId == null || _selectedDate == null)
                      ? null
                      : _onSelectPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(9),
                        ),
                      ),
                      child: const Text(
                        'Select',
                        style: AppTextStyles.body16,
                      ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
