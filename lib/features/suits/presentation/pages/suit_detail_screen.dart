// features/suits/presentation/pages/suit_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import 'package:gentleman/features/suits/domain/entities/suit_entity.dart';
import '../../../clients/presentation/pages/clients_screen.dart';
import '../../../clients/presentation/widgets/lease_result.dart';
import '../../domain/entities/suit_entity.dart'; 

class SuitDetailScreen extends StatefulWidget {
  final SuitEntity suit;
  final ValueChanged<SuitEntity> onUpdate;

  const SuitDetailScreen({
    super.key, 
    required this.suit, 
    required this.onUpdate
  });

  @override
  State<SuitDetailScreen> createState() => _SuitDetailScreenState();
}

class _SuitDetailScreenState extends State<SuitDetailScreen> {
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
  );

  setState(() {
    _suit = updated;
  });
  widget.onUpdate(updated);
  Navigator.pop(context);
}

  void _onReturned() {
  final updated = _suit.copyWith(
    status: SuitStatus.inStock, 
    clearDateLabel: true);
  setState(() {
    _suit = updated;
  });
  widget.onUpdate(updated);
  Navigator.pop(context);
}

  void _onOverdue() {
  final updated = _suit.copyWith(status: SuitStatus.overdue, dateLabel: '1 day overdue');
  setState(() {
    _suit = updated;
  });
  widget.onUpdate(updated);
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
                      child: const Text('Your suits', style: AppTextStyles.suits),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          _suit.imagePath,
                          width: double.infinity,
                          height: 320,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Text(
                          _suit.name,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline28,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_suit.brand, style: AppTextStyles.body16),
                        ),
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
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_suit.description, style: AppTextStyles.body16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _buildActionButtons(),
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

  Widget _buildActionButtons() {
    if (_suit.status == SuitStatus.inStock) {
      return Column(
        children: [
          _actionButton('New lease', AppColors.accent, _onNewLease),
          const SizedBox(height: 10),
          _outlinedButton('Edit suit', () {
            // TODO: Navigator.push -> Add/Edit suit (1.3)
          }),
        ],
      );
    }

    return Column(
      children: [
        _actionButton('The suit is returned', AppColors.accent, _onReturned),
        const SizedBox(height: 10),
        _actionButton('The suit\'s overdue', AppColors.wine, _onOverdue),
        const SizedBox(height: 10),
        _outlinedButton('Edit suit', () {
          // TODO: Navigator.push -> Add/Edit suit (1.3)
        }),
      ],
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _outlinedButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}