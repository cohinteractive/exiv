import 'package:flutter/material.dart';

/// Defines the supported LLM models for CodexVault.
enum LLMModel { gpt35, gemini15 }

/// Holds the currently selected [LLMModel].
final ValueNotifier<LLMModel> currentModel =
    ValueNotifier<LLMModel>(LLMModel.gpt35);
