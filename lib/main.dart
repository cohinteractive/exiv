import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'menu_constants.dart';
import 'menu_router.dart';
import 'search_filter_controller.dart';
import 'filter_state.dart';
import 'llm_state.dart';
import 'conversation_state.dart';
import 'selection_state.dart';
import 'ui/widgets/resizable_widget.dart';

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

class ScaffoldWithMenu extends StatefulWidget {
  const ScaffoldWithMenu({super.key});

  @override
  State<ScaffoldWithMenu> createState() => _ScaffoldWithMenuState();

}

class _ScaffoldWithMenuState extends State<ScaffoldWithMenu> {
  @override
  void dispose() {
    SearchFilterController.searchController.dispose();
    SearchFilterController.filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const MenuBarWidget(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: SearchFilterController.searchController,
                          onChanged: (value) =>
                              debugPrint('Search updated: $value'),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: SearchFilterController.filterController,
                          onChanged: (value) =>
                              debugPrint('Filter updated: $value'),
                          decoration: InputDecoration(
                            hintText: 'Filter...',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ValueListenableBuilder<String>(
                        valueListenable: FilterState.selectedFilter,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            hint: const Text('Select Filter Type'),
                            value: value,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                FilterState.selectedFilter.value = newValue;
                                debugPrint('Filter type selected: $newValue');
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: 'Vaults',
                                child: Text('Vaults'),
                              ),
                              DropdownMenuItem(
                                value: 'Conversations',
                                child: Text('Conversations'),
                              ),
                              DropdownMenuItem(
                                value: 'Exchanges',
                                child: Text('Exchanges'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
                Expanded(
                  child: Row(
                    children: [
                ResizableWidget(
                  minWidth: 200,
                  maxWidth: 500,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: ListView(
                      children: [
                        ListTile(
                          dense: true,
                          title: const Text('Vault A'),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          onTap: () =>
                              selectedItemLabel.value = 'Selected: Vault A',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ListTile(
                            dense: true,
                            title: const Text('Conversation A1'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => selectedItemLabel.value =
                                'Selected: Conversation A1',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ListTile(
                            dense: true,
                            title: const Text('Conversation A2'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => selectedItemLabel.value =
                                'Selected: Conversation A2',
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('Vault B'),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          onTap: () =>
                              selectedItemLabel.value = 'Selected: Vault B',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ListTile(
                            dense: true,
                            title: const Text('Conversation B1'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => selectedItemLabel.value =
                                'Selected: Conversation B1',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Conversation A1',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date / Metadata',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Divider(),
                              Text(
                                'User:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Assistant:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                              ),
                              const Divider(),
                              Text(
                                'User:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ut enim ad minim veniam, quis nostrud '
                                'exercitation ullamco laboris nisi ut '
                                'aliquip ex ea commodo consequat. ',
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Assistant:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Duis aute irure dolor in reprehenderit in '
                                'voluptate velit esse cillum dolore eu '
                                'fugiat nulla pariatur.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  ValueListenableBuilder<LLMModel>(
                    valueListenable: currentModel,
                    builder: (context, value, child) {
                      final label = value == LLMModel.gpt35
                          ? 'Model: GPT 3.5-turbo'
                          : 'Model: Gemini 1.5';
                      return Text(
                        label,
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: conversationCount,
                    builder: (context, count, child) {
                      return Text(
                        'Conversations: $count',
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<String>(
                    valueListenable: selectedItemLabel,
                    builder: (context, label, child) {
                      return Text(
                        label,
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
