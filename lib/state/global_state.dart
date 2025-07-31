import 'package:flutter/material.dart';
import '../models/models.dart';

/// Supported LLM models for CodexVault.
enum LLMModel { gpt35, gemini15 }

/// Available view modes for the application.
enum ViewMode { all, context, vault, conversation, exchange }

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

  /// Loaded vaults and their conversations.
  static final ValueNotifier<List<Vault>> conversationVaults =
      ValueNotifier<List<Vault>>([]);

  /// Currently selected conversation from the navigation panel.
  static final ValueNotifier<Conversation?> selectedConversation =
      ValueNotifier<Conversation?>(null);

  /// Title of the conversation currently hovered in the navigation panel.
  static final ValueNotifier<String?> hoveredConversationTitle =
      ValueNotifier<String?>(null);
}
