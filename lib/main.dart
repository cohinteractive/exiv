import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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

  void _printAction(String action) {
    // ignore: avoid_print
    print('Selected: $action');
  }

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: [
        SubmenuButton(
          menuChildren: [
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => _printAction('Open Json'),
                  child: const Text('Json'),
                ),
                MenuItemButton(
                  onPressed: () => _printAction('Open Vault'),
                  child: const Text('Vault'),
                ),
              ],
              child: const Text('Open'),
            ),
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => _printAction('Export Placeholder1'),
                  child: const Text('Placeholder1'),
                ),
                MenuItemButton(
                  onPressed: () => _printAction('Export Placeholder2'),
                  child: const Text('Placeholder2'),
                ),
              ],
              child: const Text('Export'),
            ),
            MenuItemButton(
              onPressed: () => _printAction('Exit'),
              child: const Text('Exit'),
            ),
          ],
          child: const Text('File'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () => _printAction('View Context'),
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
                  onPressed: () => _printAction('Selected GPT 3.5-turbo'),
                  child: const Text('GPT 3.5-turbo'),
                ),
                MenuItemButton(
                  onPressed: () => _printAction('Selected Gemini 1.5'),
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
