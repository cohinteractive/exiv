import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'menu_constants.dart';
import 'menu_router.dart';
import 'search_filter_controller.dart';
import 'filter_state.dart';
import 'state/global_state.dart';
import 'data/mock_data_loader.dart';
import 'ui/widgets/resizable_widget.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMaximumSize(const Size(1920, 1080));
    await windowManager.maximize();
    await windowManager.setPreventClose(false);
    await windowManager.show();
  });

  // Load mock data into global state before running the app.
  final vaults = MockDataLoader.load();
  GlobalState.conversationVaults.value = vaults;
  GlobalState.conversationCount.value =
      vaults.fold(0, (sum, v) => sum + v.conversations.length);

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const ScaffoldWithMenu(),
      ),
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
      body: SafeArea(
        child: Column(
          children: [
          Expanded(
            child: Column(
              children: [
                Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: ValueListenableBuilder<ViewMode>(
                      valueListenable: GlobalState.currentViewMode,
                      builder: (context, mode, child) {
                        if (mode == ViewMode.context) {
                          return ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  'Context Blocks',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium,
                                ),
                              ),
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.description_outlined),
                                title: const Text('Context Block A'),
                                onTap: () => GlobalState.selectedItemLabel.value =
                                    'Selected: Context Block A',
                              ),
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.description_outlined),
                                title: const Text('Context Block B'),
                                onTap: () => GlobalState.selectedItemLabel.value =
                                    'Selected: Context Block B',
                              ),
                            ],
                          );
                        }
                        return ValueListenableBuilder<List<Vault>>(
                          valueListenable: GlobalState.conversationVaults,
                          builder: (context, vaults, child) {
                            return ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    'Vaults',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                                for (final vault in vaults)
                                  ExpansionTile(
                                    leading: const Icon(Icons.folder),
                                    title: Text(vault.name),
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                        GlobalState.selectedItemLabel.value =
                                            'Selected: ${vault.name}';
                                      }
                                    },
                                    children: [
                                      for (final convo in vault.conversations)
                                        ValueListenableBuilder<String?>(
                                          valueListenable:
                                              GlobalState.hoveredConversationTitle,
                                          builder: (context, hovered, child) {
                                            final isHovered = hovered == convo.title;
                                            return MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              onEnter: (_) {
                                                GlobalState.hoveredConversationTitle
                                                    .value = convo.title;
                                                debugPrint('Hover: ${convo.title}');
                                              },
                                              onExit: (_) {
                                                if (GlobalState
                                                        .hoveredConversationTitle
                                                        .value ==
                                                    convo.title) {
                                                  GlobalState.hoveredConversationTitle
                                                      .value = null;
                                                }
                                              },
                                              child: ListTile(
                                                dense: true,
                                                leading: const Icon(Icons.chat),
                                                title: Text(
                                                  convo.title,
                                                  style: isHovered
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight.bold)
                                                      : null,
                                                ),
                                                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(convo.timestamp)),
                                                trailing:
                                                    const Icon(Icons.chevron_right),
                                                tileColor: isHovered
                                                    ? Theme.of(context).hoverColor
                                                    : null,
                                                onTap: () {
                                                  GlobalState.selectedItemLabel
                                                          .value =
                                                      'Selected: ${convo.title}';
                                                  GlobalState.selectedConversation
                                                      .value = convo;
                                                },
        ),
      ),
                                          },
                                        ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: ValueListenableBuilder<Conversation?>(
                      valueListenable: GlobalState.selectedConversation,
                      builder: (context, convo, child) {
                        if (convo == null) {
                          return Center(
                            child: Text(
                              'No conversation selected',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  convo.title,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm').format(convo.timestamp),
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User prompt placeholder',
                                          style: Theme.of(context)
                                              .textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Assistant response placeholder',
                                          style: Theme.of(context)
                                              .textTheme.bodyMedium,
                                        ),
                                        const Divider(),
                                        Text(
                                          'User prompt placeholder',
                                          style: Theme.of(context)
                                              .textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Assistant response placeholder',
                                          style: Theme.of(context)
                                              .textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ValueListenableBuilder<LLMModel>(
                    valueListenable: GlobalState.currentModel,
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
                    valueListenable: GlobalState.conversationCount,
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
                    valueListenable: GlobalState.selectedItemLabel,
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
              onPressed: () => MenuRouter.handle(MenuActions.viewAll),
              child: const Text('All'),
            ),
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
