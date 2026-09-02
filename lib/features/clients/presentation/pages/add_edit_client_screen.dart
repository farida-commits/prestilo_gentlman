// features/clients/presentation/pages/add_edit_client_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gentleman/features/clients/presentation/widgets/client_photo_picker.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../suits/presentation/widgets/required_field_label.dart';
import '../../../suits/presentation/widgets/suit_text_field.dart';
import '../../../suits/presentation/widgets/confirm_dialog.dart';
import '../../data/datasources/client_local_datasource.dart';
import '../../../rental_history/domain/entities/rental_record_entity.dart';
import '../../../rental_history/data/datasources/rental_local_datasource.dart';
import '../widgets/suit_history_mini_card.dart';

class AddEditClientScreen extends StatefulWidget {
  final ClientEntity? existingClient;

  const AddEditClientScreen({super.key, this.existingClient});

  @override
  State<AddEditClientScreen> createState() => _AddEditClientScreenState();
}

class _AddEditClientScreenState extends State<AddEditClientScreen> {
  final ClientLocalDataSource _clientDataSource = ClientLocalDataSource();
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  String? _imagePath;
  Uint8List? _decodedBytes;
  bool _hasChanges = false;
  List<RentalRecordEntity> _clientRecords = [];

  bool get _isEditMode => widget.existingClient != null;

  bool get _isFormValid =>
      _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final client = widget.existingClient;
    _nameCtrl = TextEditingController(text: client?.name ?? '');
    _phoneCtrl = TextEditingController(text: client?.phone ?? '');
    _imagePath = client?.photoPath;
    if (_isEditMode) _loadRecords();
  }

  Future<void> _loadRecords() async {
    final all = await _rentalDataSource.getAllRecords();
    setState(() {
      _clientRecords = all
          .where((r) => r.clientId == widget.existingClient!.id)
          .toList();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _markChanged() {
    setState(() => _hasChanges = true);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imagePath = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          _decodedBytes = bytes;
          _hasChanges = true;
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  void _deleteImage() {
    setState(() {
      _imagePath = null;
      _decodedBytes = null;
      _hasChanges = true;
    });
  }

  Future<void> _onBackPressed() async {
    if (!_isEditMode && _hasChanges) {
      final leave = await ConfirmDialog.show(
        context,
        title: 'Leave the screen?',
        message: 'If you leave, any changes you have made will not be saved',
        confirmText: 'Leave',
      );
      if (leave && mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onDeleteClient() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete clients card',
      message:
          'Are you sure you want to remove this client card? This action cannot be canceled.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      await _clientDataSource.deleteClient(widget.existingClient!.id);
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _onDeleteRecord(RentalRecordEntity record) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete this history card',
      message:
          'Are you sure you want to remove this history card? This action cannot be canceled.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      await _rentalDataSource.deleteRecord(record.id);
      setState(() => _clientRecords.removeWhere((r) => r.id == record.id));
    }
  }

  Future<void> _save() async {
    if (!_isFormValid) return;

    final client = ClientEntity(
      id:
          widget.existingClient?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      photoPath: _imagePath,
    );

    await _clientDataSource.saveClient(client);
    if (mounted) Navigator.pop(context, client);
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
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildTopBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    children: [
                      RequiredFieldLabel(
                        text: 'Enter the name of the clients',
                        isFilled: _nameCtrl.text.trim().isNotEmpty,
                      ),
                      const SizedBox(height: 6),
                      SuitTextField(
                        controller: _nameCtrl,
                        hint: 'Name clients',
                        onChanged: () {
                          _markChanged();
                          if (_isEditMode) _save();
                        },
                      ),
                      const SizedBox(height: 16),
                      RequiredFieldLabel(
                        text: 'Add a photo clients (optionals)',
                        isFilled: _imagePath != null,
                      ),
                      const SizedBox(height: 6),
                      ClientPhotoPicker(
                        imagePath: _imagePath,
                        cachedBytes: _decodedBytes,
                        showDelete: _isEditMode,
                        onPick: () async {
                          await _pickImage();
                          if (_isEditMode) await _save();
                        },
                        onDelete: () {
                          _deleteImage();
                          if (_isEditMode) _save();
                        },
                      ),
                      const SizedBox(height: 16),
                      RequiredFieldLabel(
                        text: "Enter customer's phone number",
                        isFilled: _phoneCtrl.text.trim().isNotEmpty,
                      ),
                      const SizedBox(height: 6),
                      SuitTextField(
                        controller: _phoneCtrl,
                        hint: 'Enter phone number',
                        keyboardType: TextInputType.number,
                        onChanged: () {
                          _markChanged();
                          if (_isEditMode) _save();
                        },
                      ),
                      if (_isEditMode) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "The last day a user rented a suit",
                          style: AppTextStyles.caption12,
                        ),
                        const SizedBox(height: 8),
                        ..._clientRecords.map(
                          (record) => SuitHistoryMiniCard(
                            record: record,
                            onDelete: () => _onDeleteRecord(record),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: _onBackPressed,
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
              child: Text(
                _isEditMode ? 'Edit clients' : 'Create clients',
                style: AppTextStyles.headline28,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (_isEditMode)
            GestureDetector(
              onTap: _onDeleteClient,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.wine,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Image.asset(
                  'assets/images/delete.png',
                  width: 30,
                  height: 30,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _isFormValid ? _save : null,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _isFormValid
                      ? AppColors.accent
                      : AppColors.accent.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(9),
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
    );
  }
}
