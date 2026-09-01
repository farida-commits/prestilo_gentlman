// features/suits/presentation/pages/suit_detail_screen.dart
import 'dart:ui';
import 'package:gentleman/features/suits/domain/entities/suit_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';
import '../../../clients/presentation/pages/clients_screen.dart';
import '../../../clients/presentation/widgets/lease_result.dart';
import '../../../rental_history/domain/entities/rental_record_entity.dart';
import '../../../rental_history/data/datasources/rental_local_datasource.dart';
import 'add_edit_suit_screen.dart';

class SuitDetailScreen extends StatefulWidget {
  final SuitEntity suit;
  final ValueChanged<SuitEntity> onUpdate;
  final VoidCallback? onDelete;

  const SuitDetailScreen({
    super.key,
    required this.suit,
    required this.onUpdate,
    this.onDelete,
  });

  @override
  State<SuitDetailScreen> createState() => _SuitDetailScreenState();
}

class _SuitDetailScreenState extends State<SuitDetailScreen> {
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();
  late SuitEntity _suit;

  @override
  void initState() {
    super.initState();
    _suit = widget.suit;
  }

  Future<void> _onNewLease() async {
    final result = await Navigator.push<LeaseResult>(
      context,
      MaterialPageRoute(builder: (_) => const ClientsScreen()),
    );

    if (result == null || !mounted) return;

    final formatter = DateFormat('dd.MM.yyyy');
    final updated = _suit.copyWith(
      status: SuitStatus.leased,
      dateLabel: formatter.format(result.endDate),
      currentClientId: result.client.id,
      currentClientName: result.client.name,
    );

    setState(() => _suit = updated);
    widget.onUpdate(updated);
    Navigator.pop(context);
  }

  Future<void> _onReturned() async {
    // Аренда тарыхка кошулат (эгер клиент маалыматы бар болсо)
    if (_suit.currentClientId != null) {
      final record = RentalRecordEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        suitId: _suit.id,
        suitName: _suit.name,
        suitImagePath: _suit.imagePath,
        suitBrand: _suit.brand,
        suitPrice: _suit.price,
        suitFabric: _suit.fabric,
        suitSize: _suit.size,
        clientId: _suit.currentClientId!,
        clientName: _suit.currentClientName ?? '',
        rentalDate: _suit.dateLabel ?? DateFormat('dd.MM.yyyy').format(DateTime.now()),
        profit: _suit.price,
      );
      await _rentalDataSource.addRecord(record);
    }

    final updated = _suit.copyWith(
      status: SuitStatus.inStock,
      clearDateLabel: true,
      clearCurrentClient: true,
    );
    setState(() => _suit = updated);
    widget.onUpdate(updated);
    if (mounted) Navigator.pop(context);
  }

  void _onOverdue() {
    final updated = _suit.copyWith(status: SuitStatus.overdue, dateLabel: '1 day overdue');
    setState(() => _suit = updated);
    widget.onUpdate(updated);
  }

    Future<void> _onEditSuit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditSuitScreen(
          existingSuit: _suit,
          onSave: (updatedSuit) {
            widget.onUpdate(updatedSuit);
            setState(() => _suit = updatedSuit);
          },
          onDelete: () {
            widget.onDelete?.call();
            Navigator.pop(context);
          },
        ),
      ),
    );
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
                          width: 32,
                          height: 32,
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Your suits', style: AppTextStyles.suits),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                    padding: const EdgeInsets.fromLTRB(35, 0, 35, 130),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.bmain,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9),)
                            ),
                            child: Text(
                            _suit.name,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headline28,
                          ),
                          ),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: SuitImageWidget(
                                    imagePath: _suit.imagePath,
                                    width: double.infinity,
                                    height: 295,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.bmain,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(_suit.brand, style: AppTextStyles.captionBold12),
                                  ),
                                ),
                              ],
                            ),
                          
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Suit price per day of rental', style: AppTextStyles.caption12),
                      const SizedBox(height: 6),
                      _fieldBox('\$ ${_suit.price}'),
                      const SizedBox(height: 16),
                      const Text('Deposit for a suit', style: AppTextStyles.caption12),
                      const SizedBox(height: 6),
                      _fieldBox('\$ ${_suit.deposit}'),
                      const SizedBox(height: 16),
                      const Text('Enter the fabric of the model', style: AppTextStyles.caption12),
                      const SizedBox(height: 6),
                      _fieldBox(_suit.fabric),
                      const SizedBox(height: 16),
                      const Text('Enter the size of the model (EU size)', style: AppTextStyles.caption12),
                      const SizedBox(height: 6),
                      _fieldBox(_suit.size),
                      const SizedBox(height: 16),
                      const Text('Enter a description of this suit', style: AppTextStyles.caption12),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bmain,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(_suit.description, style: AppTextStyles.body16),
                      ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    left: 35,
                    right: 35,
                    bottom: 16,
                    child: _buildActionButtons(),
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

  Widget _fieldBox(String value) {
    return Container(
      width: double.infinity,
      height: 44,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.bmain,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(value, style: AppTextStyles.body16),
    );
  }

  Widget _buildActionButtons() {
    if (_suit.status == SuitStatus.inStock) {
      return Column(
        children: [
          _actionButton(
            'New lease',
             AppColors.accent,
              _onNewLease
          ),
          const SizedBox(height: 10),
          _outlinedButton('Edit suit', _onEditSuit),
        ],
      );
    }

    return Column(
      children: [
        _actionButton('The suit is returned', AppColors.accent, _onReturned),
        const SizedBox(height: 10),
        _actionButton('The suit\'s overdue', AppColors.wine, _onOverdue),
        const SizedBox(height: 10),
        _outlinedButton('Edit suit', _onEditSuit),
      ],
    );
  }

  Widget _actionButton(
    String text, 
    Color color, 
    VoidCallback onTap
  ) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(
          text, 
          style: AppTextStyles.body16
        ),
      ),
    );
  }

  Widget _outlinedButton(String text, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),           
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.accent, width: 2),
        ),
        child: TextButton(
          onPressed: onTap,
           style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.body16,
          ),
        ),
      ),
    ),      
    );
  }
}