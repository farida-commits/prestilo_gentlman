// features/suits/presentation/pages/suits_main_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/suit_entity.dart';
import '../widgets/suit_card.dart';
import '../widgets/suits_tab_bar.dart';
import '../widgets/suits_bottom_nav.dart';
import 'package:gentleman/features/suits/presentation/pages/suit_detail_screen.dart';

class SuitsMainScreen extends StatefulWidget {
  const SuitsMainScreen({super.key});

  @override
  State<SuitsMainScreen> createState() => _SuitsMainScreenState();
}

class _SuitsMainScreenState extends State<SuitsMainScreen> {
  // mock data — кийин Hive'дан алабыз
  final List<SuitEntity> _suits = [
    const SuitEntity(
      id: '1',
      name: 'Black Tie Classic',
      brand: 'Hugo Boss',
      price: '\$450',
      fabric: '100% Wool',
      size: '50',
      imagePath: 'assets/images/suit_1.png',
      status: SuitStatus.inStock,
      description: 'ddd1',
      deposit: '1',
    ),
    const SuitEntity(
      id: '2',
      name: 'Royal Navy Suit',
      brand: 'Tom Ford',
      price: '\$600',
      fabric: 'Wool & Cashmere',
      size: '48',
      imagePath: 'assets/images/suit_2.png',
      status: SuitStatus.overdue,
      dateLabel: '2 days overdue',
      description: 'ddd2',
      deposit: '2',
    ),
    const SuitEntity(
      id: '3',
      name: 'Vintage Tails 1920',
      brand: 'Tailcoat (Vintage)',
      price: '\$1200',
      fabric: 'Wool with Satin',
      size: '50',
      imagePath: 'assets/images/suit_3.png',
      status: SuitStatus.leased,
      dateLabel: '31.10.2025',
      description: 'ddd3',
      deposit: '3',
    ),
    const SuitEntity(
      id: '4',
      name: 'Summer Linen Set',
      brand: 'Massimo Dutti',
      price: '\$300',
      fabric: '100% Linen',
      size: '47',
      imagePath: 'assets/images/suit_4.png',
      status: SuitStatus.leased,
      dateLabel: '29.10.2025',
      description: 'ddd4',
      deposit: '4',
    ),
    const SuitEntity(
      id: '5',
      name: 'Velvet Burgundy Jacket',
      brand: 'Massimo Dutti',
      price: '\$250',
      fabric: 'Velvet',
      size: '49',
      imagePath: 'assets/images/suit_1.png',
      status: SuitStatus.inStock,
      description: 'ddd5',
      deposit: '5',
    ),
  ];

  SuitFilter _filter = SuitFilter.all;
  bool _isSearching = false;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

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

  void _openSearch() {
    setState(() => _isSearching = true);
  }

  void _closeSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _query = '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildTopBar(),
                if (!isEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SuitDetailScreen(
                                            suit: suit,
                                            onUpdate: (updatedSuit) {
  setState(() {
    final idx = _suits.indexWhere((s) => s.id == updatedSuit.id);
    if (idx != -1) {
      _suits[idx] = updatedSuit;
    }
  });
},
                                          ),
                                        ),
                                      );
                                    },
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

  Widget _buildTopBar() {
    if (_isSearching) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white54, size: 20),
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
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white38),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.wine,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (_searchEnabled) ...[
            GestureDetector(
              onTap: _openSearch,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.search, color: Colors.white),
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
              child: const Text('Suits', style: AppTextStyles.suits),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              // TODO: Navigator.push -> Add / Edit suit (1.3)
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
            const Text('No suit', style: AppTextStyles.headline28),
            const SizedBox(height: 8),
            Text(
              'Add your first costume for easy\nstorage of them',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption12.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigator.push -> Add / Edit suit (1.3)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create new suit',
                  style: TextStyle(color: Colors.white),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.navy.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nothing found', style: AppTextStyles.headline28),
            const SizedBox(height: 8),
            Text(
              'There was no suit to meet your\nrequirements',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption12.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
