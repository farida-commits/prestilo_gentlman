// features/suits/presentation/pages/add_edit_suit_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/suit_entity.dart';
import '../widgets/required_field_label.dart';
import '../widgets/suit_text_field.dart';
import '../widgets/suit_image_picker.dart';
import '../widgets/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/photo_access_dialog.dart';

class AddEditSuitScreen extends StatefulWidget {
  final SuitEntity? existingSuit;
  final ValueChanged<SuitEntity> onSave;
  final VoidCallback? onDelete;

  const AddEditSuitScreen({
    super.key,
    this.existingSuit,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditSuitScreen> createState() => _AddEditSuitScreenState();
}

class _AddEditSuitScreenState extends State<AddEditSuitScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _depositCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _fabricCtrl;
  late final TextEditingController _sizeCtrl;
  late final TextEditingController _descriptionCtrl;

  String? _imagePath;
  Uint8List? _decodedBytes;
  bool _hasChanges = false;

  bool get _isEditMode => widget.existingSuit != null;

  bool get _isFormValid {
    if (_isEditMode) {
      // Edit режим - image может быть старая или новая
      return _nameCtrl.text.trim().isNotEmpty &&
          _imagePath != null &&
          _priceCtrl.text.trim().isNotEmpty &&
          _sizeCtrl.text.trim().isNotEmpty;
    } else {
      // Create режим - нужна новая картинка
      return _nameCtrl.text.trim().isNotEmpty &&
          _imagePath != null &&
          _priceCtrl.text.trim().isNotEmpty &&
          _sizeCtrl.text.trim().isNotEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    final suit = widget.existingSuit;
    _nameCtrl = TextEditingController(text: suit?.name ?? '');
    _priceCtrl = TextEditingController(text: suit?.price ?? '');
    _depositCtrl = TextEditingController(text: suit?.deposit ?? '');
    _brandCtrl = TextEditingController(text: suit?.brand ?? '');
    _fabricCtrl = TextEditingController(text: suit?.fabric ?? '');
    _sizeCtrl = TextEditingController(text: suit?.size ?? '');
    _descriptionCtrl = TextEditingController(text: suit?.description ?? '');
    _imagePath = suit?.imagePath;
    _hasChanges = false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _depositCtrl.dispose();
    _brandCtrl.dispose();
    _fabricCtrl.dispose();
    _sizeCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges)
      setState(() => _hasChanges = true);
    else
      setState(() {});
  }

  Future<void> _pickImage() async {
    final prefs = await SharedPreferences.getInstance();
    final bool alreadyAllowed = prefs.getBool('photo_access_allowed') ?? false;

    if (!alreadyAllowed) {
      if (!mounted) return;
      final choice = await PhotoAccessDialog.show(context);

      if (choice == null || choice == 'deny') {
        // "Don't Allow" — "No Access" alert чыгат, кийинки жолу кайра сурайт (flag сакталбайт)
        if (!mounted) return;
        final goToSettings = await ConfirmDialog.show(
          context,
          title: 'No Access to Your Photos',
          message:
              'Allow photo access so you can upload \npictures of your suit',
          confirmText: 'Settings',
        );
        if (goToSettings) {
          openAppSettings();
        }
        return;
      }

      if (choice == 'allow_all') {
        await prefs.setBool('photo_access_allowed', true);
      }
    }

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

  Future<void> _deleteImage() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete photo',
      message:
          'Are you sure you want to remove this \nphoto? This action cannot be \ncanceled.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      setState(() {
        _imagePath = null;
        _decodedBytes = null;
        _hasChanges = true;
      });
    }
  }

  Future<void> _onBackPressed() async {
    if (_isEditMode && _hasChanges) {
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

  Future<void> _onDeleteSuit() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete suit',
      message:
          'Are you sure you want to remove this suit? This action cannot be canceled.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      widget.onDelete?.call();
      if (mounted) Navigator.pop(context);
    }
  }

  void _onSubmit() {
  if (!_isFormValid) return;

  final suit = SuitEntity(
    id: widget.existingSuit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: _nameCtrl.text.trim(),
    brand: _brandCtrl.text.trim(),
    price: _priceCtrl.text.trim(),
    deposit: _depositCtrl.text.trim(),
    fabric: _fabricCtrl.text.trim(),
    size: _sizeCtrl.text.trim(),
    description: _descriptionCtrl.text.trim(),
    imagePath: _imagePath ?? 'assets/images/placeholder.png',
    status: widget.existingSuit?.status ?? SuitStatus.inStock,
    dateLabel: widget.existingSuit?.dateLabel,
  );

  widget.onSave(suit);
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) _onBackPressed();
      },
      child: Scaffold(
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
                  _buildTopBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      children: [
                        RequiredFieldLabel(
                          text: 'Enter the name of the suit',
                          isFilled: _nameCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _nameCtrl,
                          hint: 'Name of the suit',
                          isNumberOnly: false,
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Add a picture of the costume',
                          isFilled: _imagePath != null,
                        ),
                        const SizedBox(height: 6),
                        SuitImagePicker(
                          imagePath: _imagePath,
                          cachedBytes: _decodedBytes,
                          onPick: _pickImage,
                          onDelete: _deleteImage,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Suit price per day of rental',
                          isFilled: _priceCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _priceCtrl,
                          hint: 'Price',
                          isDollar: true,
                          keyboardType: TextInputType.number,
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Deposit for a suit',
                          isFilled: _depositCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _depositCtrl,
                          hint: 'Deposit (optional)',
                          isDollar: true,
                          keyboardType: TextInputType.number,
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Enter the brand of the model',
                          isFilled: _brandCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _brandCtrl,
                          hint: 'Brand (optional)',
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Enter the fabric of the model',
                          isFilled: _fabricCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _fabricCtrl,
                          hint: 'Fabric (optional)',
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Enter the size of the model',
                          isFilled: _sizeCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _sizeCtrl,
                          hint: 'Enter the size',
                          keyboardType: TextInputType.number,
                          onChanged: _markChanged,
                        ),
                        const SizedBox(height: 16),
                        RequiredFieldLabel(
                          text: 'Enter a description of this suit',
                          isFilled: _descriptionCtrl.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 6),
                        SuitTextField(
                          controller: _descriptionCtrl,
                          hint: 'Enter a description (optional)',
                          isMultiline: true,
                          onChanged: _markChanged,
                        ),
                        if (_isEditMode) ...[
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _onDeleteSuit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.wine,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: const Text(
                                'Delete this suit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final bool actionEnabled = _isEditMode
        ? (_hasChanges && _isFormValid)
        : _isFormValid;

    debugPrint('Price raw: "${_priceCtrl.text}"');
    debugPrint('Size raw: "${_sizeCtrl.text}"');
    debugPrint('=== FULL FORM STATUS ===');
    debugPrint(
      'Name: ${_nameCtrl.text.trim().isNotEmpty} ("${_nameCtrl.text}")',
    );
    debugPrint('Image: ${_imagePath != null}');
    debugPrint(
      'Price: ${_priceCtrl.text.trim().isNotEmpty} ("${_priceCtrl.text}")',
    );
    debugPrint(
      'Size: ${_sizeCtrl.text.trim().isNotEmpty} ("${_sizeCtrl.text}")',
    );
    debugPrint('isFormValid: $_isFormValid');
    debugPrint('actionEnabled: $actionEnabled');

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
                borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                _isEditMode ? 'Edit suits' : 'Create suits',
                style: AppTextStyles.suits,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: actionEnabled ? _onSubmit : null,
            borderRadius: BorderRadius.circular(9),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: actionEnabled
                    ? AppColors.accent
                    : AppColors.accent.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Image.asset(
                width: 32,
                height: 32,
                _isEditMode
                    ? 'assets/images/close.png'
                    : 'assets/images/plus.png',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
