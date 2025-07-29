import 'package:flutter/material.dart';

/// Manages the currently selected filter type for the filter dropdown.
class FilterState {
  /// Selected filter type displayed in the dropdown. Defaults to 'All'.
  static final ValueNotifier<String> selectedFilter =
      ValueNotifier<String>('All');
}
