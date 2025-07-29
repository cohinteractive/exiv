import 'package:flutter/material.dart';

/// Provides centralized controllers for search and filter text fields.
class SearchFilterController {
  /// Controller for the search input field.
  static final TextEditingController searchController = TextEditingController();

  /// Controller for the filter input field.
  static final TextEditingController filterController = TextEditingController();
}
