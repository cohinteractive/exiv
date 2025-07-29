import 'package:flutter/material.dart';

/// Supported LLM models for CodexVault.
enum LLMModel { gpt35, gemini15 }

/// Available view modes for the application.
enum ViewMode { all, vault, conversation, exchange }

/// Provides global state notifiers for the UI.
class GlobalState {
  /// Currently selected language model.
  static final ValueNotifier<LLMModel> currentModel =
      ValueNotifier<LLMModel>(LLMModel.gpt35);

  /// Currently active view mode.
  static final ValueNotifier<ViewMode> currentViewMode =
      ValueNotifier<ViewMode>(ViewMode.all);

  /// Label of the selected navigation item.
  static final ValueNotifier<String> selectedItemLabel =
      ValueNotifier<String>('No item selected');

  /// Number of loaded conversations.
  static final ValueNotifier<int> conversationCount =
      ValueNotifier<int>(0);
}
