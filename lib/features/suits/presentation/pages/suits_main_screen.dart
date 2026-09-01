// features/suits/presentation/pages/suits_main_screen.dart — толук алмаштыр
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/suit_local_datasource.dart';
import '../../domain/entities/suit_entity.dart';
import '../widgets/suit_card.dart';
import '../widgets/suits_tab_bar.dart';
import '../widgets/suits_bottom_nav.dart';
import 'add_edit_suit_screen.dart';
import 'suit_detail_screen.dart';

class SuitsMainScreen extends StatefulWidget {
  const SuitsMainScreen({super.key});

  @override
  State<SuitsMainScreen> createState() => _SuitsMainScreenState();
}

class _SuitsMainScreenState extends State<SuitsMainScreen> {
  final SuitLocalDataSource _dataSource = SuitLocalDataSource();

  List<SuitEntity> _suits = [];
  bool _isLoading = true;

  SuitFilter _filter = SuitFilter.all;
  bool _isSearching = false;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSuits();
  }

  Future<void> _loadSuits() async {
    setState(() => _isLoading = true);

    final suits = await _dataSource.getAllSuits();
    setState(() {
      _suits = suits;
      _isLoading = false;
    });
  }

  Future<void> _saveSuit(SuitEntity suit) async {
    await _dataSource.saveSuit(suit);
    setState(() {
      final idx = _suits.indexWhere((s) => s.id == suit.id);
      if (idx != -1) {
        _suits[idx] = suit;
      } else {
        _suits.add(suit);
      }
    });
  }

  Future<void> _deleteSuit(String id) async {
    await _dataSource.deleteSuit(id);
    setState(() => _suits.removeWhere((s) => s.id == id));
  }

  bool get _hasLeasedSuits => _suits.any(
    (s) => s.status == SuitStatus.leased || s.status == SuitStatus.overdue,
  );

  bool get _searchEnabled => _suits.length >= 5;

  List<SuitEntity> get _filteredSuits {
    Iterable<SuitEntity> result = _suits;

    switch (_filter) {
      case SuitFilter.all:
        break;
      case SuitFilter.inStock:
        result = result.where((s) => s.status == SuitStatus.inStock);
        break;
      case SuitFilter.leased:
        result = result.where(
          (s) =>
              s.status == SuitStatus.leased || s.status == SuitStatus.overdue,
        );
        break;
    }

    if (_query.trim().isNotEmpty) {
      result = result.where(
        (s) => s.name.toLowerCase().contains(_query.trim().toLowerCase()),
      );
    }

    return result.toList();
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _query = '';
    });
  }

  void _openAddSuit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditSuitScreen(onSave: _saveSuit)),
    );
  }

  void _openSuitDetail(SuitEntity suit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuitDetailScreen(suit: suit, onUpdate: _saveSuit),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final bool isEmpty = _suits.isEmpty;
    final bool noResults = !isEmpty && _filteredSuits.isEmpty;

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
                _buildTopBar(isEmpty),
                if (!isEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SuitsTabBar(
                      selected: _filter,
                      leasedEnabled: _hasLeasedSuits,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: isEmpty
                      ? _buildEmptyState()
                      : (noResults
                            ? _buildNothingFound()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: _filteredSuits.length,
                                itemBuilder: (context, index) {
                                  final suit = _filteredSuits[index];
                                  return SuitCard(
                                    suit: suit,
                                    onTap: () => _openSuitDetail(suit),
                                  );
                                },
                              )),
                ),
                if (!_isSearching)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: SuitsBottomNav(currentIndex: 0, onTap: (_) {}),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isEmpty){
    if (_isSearching) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 52,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.bmain,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/search.png', 
                      color: AppColors.grey,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                        ),
                        cursorColor: AppColors.accent,
                        decoration:  InputDecoration(
                          hintText: 'Search',
                          hintStyle: AppTextStyles.caption12.copyWith(color: AppColors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _closeSearch,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.wine,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/close.png',
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_searchEnabled) ...[
            GestureDetector(
              onTap: _openSearch,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.bmain,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Container(
            height: 52,
            width: 191,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bmain,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text('Suits', style: AppTextStyles.suits),
          ),
          if (!isEmpty) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _openAddSuit,
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: 311,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bmain,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No suit', style: AppTextStyles.headline52),
            const SizedBox(height: 8),
            Text(
              'Add your first costume for easy\nstorage of them',
              textAlign: TextAlign.center,
              style: AppTextStyles.body16.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _openAddSuit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create new suit',
                  style: AppTextStyles.body16.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNothingFound() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bmain,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nothing found', style: AppTextStyles.headline52),
                const SizedBox(height: 8),
                Text(
                  'There was no suit to meet your\nrequirements',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body16.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
