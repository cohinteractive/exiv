import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'menu_constants.dart';
import 'menu_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMaximumSize(const Size(1920, 1080));
    await windowManager.maximize();
    await windowManager.setPreventClose(false);
    await windowManager.show();
  });

  runApp(const CodexVaultApp());
}

class CodexVaultApp extends StatelessWidget {
  const CodexVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodexVault',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const ScaffoldWithMenu(),
    );
  }
}

class ScaffoldWithMenu extends StatelessWidget {
  const ScaffoldWithMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const MenuBarWidget(),
      ),
      body: const Center(child: Text('CodexVault UI Placeholder')),
    );
  }
}

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: [
        SubmenuButton(
          menuChildren: [
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => MenuRouter.handle(MenuActions.openJson),
                  child: const Text('Json'),
                ),
                MenuItemButton(
                  onPressed: () => MenuRouter.handle(MenuActions.openVault),
                  child: const Text('Vault'),
                ),
              ],
              child: const Text('Open'),
            ),
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(MenuActions.exportPlaceholder1),
                  child: const Text('Placeholder1'),
                ),
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(MenuActions.exportPlaceholder2),
                  child: const Text('Placeholder2'),
                ),
              ],
              child: const Text('Export'),
            ),
            MenuItemButton(
              onPressed: () => MenuRouter.handle(MenuActions.exitApp),
              child: const Text('Exit'),
            ),
          ],
          child: const Text('File'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () => MenuRouter.handle(MenuActions.viewContext),
              child: const Text('Context'),
            ),
          ],
          child: const Text('View'),
        ),
        SubmenuButton(
          menuChildren: [
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(MenuActions.selectModelGpt),
                  child: const Text('GPT 3.5-turbo'),
                ),
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(MenuActions.selectModelGemini),
                  child: const Text('Gemini 1.5'),
                ),
              ],
              child: const Text('Select Model'),
            ),
          ],
          child: const Text('Tools'),
        ),
      ],
    );
  }
}
