import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final String filterType;
  final String? selectedSubcategory;

  FilterState({
    this.filterType = 'All',
    this.selectedSubcategory,
  });

  FilterState copyWith({
    String? filterType,
    String? selectedSubcategory,
  }) {
    return FilterState(
      filterType: filterType ?? this.filterType,
      selectedSubcategory: selectedSubcategory ?? this.selectedSubcategory,
    );
  }
}

class FilterStateNotifier extends StateNotifier<FilterState> {
  FilterStateNotifier() : super(FilterState());

  void setFilterType(String type) {
    state = state.copyWith(filterType: type, selectedSubcategory: null);
  }

  void setSubcategory(String? subcategory) {
    state = state.copyWith(selectedSubcategory: subcategory);
  }

  void reset() {
    state = FilterState(); // Reset to default state
  }
}

final filterStateProvider = StateNotifierProvider<FilterStateNotifier, FilterState>(
  (ref) => FilterStateNotifier(),
);
