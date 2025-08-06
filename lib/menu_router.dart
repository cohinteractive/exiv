import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'menu_constants.dart';
import 'menu_action_handler.dart';
import 'services/raw_loader.dart';
import 'state/global_state.dart';

/// Routes menu action strings to their corresponding handlers in [MenuActionHandler].
class MenuRouter {
  /// Dispatches a menu [action] to the proper handler.
  static Future<void> handle(BuildContext context, String action) async {
    switch (action) {
      case MenuActions.openJson:
        MenuActionHandler.onOpenJson();
        break;
      case MenuActions.openRawJson:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
        if (result != null && result.files.single.path != null) {
          try {
            final convos =
                await RawLoader.loadRawJson(File(result.files.single.path!));
            GlobalState.conversations.value = convos;
            GlobalState.conversationCount.value = convos.length;
            GlobalState.selectedConversation.value = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Loaded ${convos.length} conversations'),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load JSON: $e')),
            );
          }
        }
        break;
      case MenuActions.openVault:
        MenuActionHandler.onOpenVault();
        break;
      case MenuActions.exportPlaceholder1:
        MenuActionHandler.onExportPlaceholder1();
        break;
      case MenuActions.exportPlaceholder2:
        MenuActionHandler.onExportPlaceholder2();
        break;
      case MenuActions.exitApp:
        MenuActionHandler.onExit();
        break;
      case MenuActions.viewAll:
        MenuActionHandler.onViewModeAll();
        break;
      case MenuActions.viewContext:
        MenuActionHandler.onViewModeContext();
        break;
      case MenuActions.selectModelGpt:
        MenuActionHandler.onSelectModelGPT();
        break;
      case MenuActions.selectModelGemini:
        MenuActionHandler.onSelectModelGemini();
        break;
    }
  }
}

