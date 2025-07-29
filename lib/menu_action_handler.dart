import 'menu_constants.dart';
import 'llm_state.dart';
import 'conversation_state.dart';

class MenuActionHandler {
  static void onOpenJson() {
    // ignore: avoid_print
    print(MenuActions.openJson);
    conversationCount.value = 42;
  }

  static void onOpenVault() {
    // ignore: avoid_print
    print(MenuActions.openVault);
    conversationCount.value = 42;
  }

  static void onExportPlaceholder1() {
    // ignore: avoid_print
    print(MenuActions.exportPlaceholder1);
  }

  static void onExportPlaceholder2() {
    // ignore: avoid_print
    print(MenuActions.exportPlaceholder2);
  }

  static void onExit() {
    // ignore: avoid_print
    print(MenuActions.exitApp);
  }

  static void onViewContext() {
    // ignore: avoid_print
    print(MenuActions.viewContext);
  }

  static void onSelectModelGPT() {
    // ignore: avoid_print
    print(MenuActions.selectModelGpt);
    currentModel.value = LLMModel.gpt35;
  }

  static void onSelectModelGemini() {
    // ignore: avoid_print
    print(MenuActions.selectModelGemini);
    currentModel.value = LLMModel.gemini15;
  }
}
