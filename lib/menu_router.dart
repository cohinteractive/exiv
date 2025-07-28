import 'menu_constants.dart';
import 'menu_action_handler.dart';

/// Routes menu action strings to their corresponding handlers in [MenuActionHandler].
class MenuRouter {
  /// Dispatches a menu [action] to the proper handler.
  static void handle(String action) {
    switch (action) {
      case MenuActions.openJson:
        MenuActionHandler.onOpenJson();
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
      case MenuActions.viewContext:
        MenuActionHandler.onViewContext();
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
