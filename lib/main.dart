import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'menu_constants.dart';
import 'menu_router.dart';
import 'search_filter_controller.dart';
import 'filter_state.dart';
import 'state/global_state.dart';
import 'ui/widgets/resizable_navigation_panel.dart';
import 'package:intl/intl.dart';
import 'models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.maximize();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const CodexVaultApp());
}

class CodexVaultApp extends StatelessWidget {
  const CodexVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.dark(
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      surfaceVariant: Color(0xFF2C2C2C),
      primary: Colors.blueGrey,
      onPrimary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    );

    final baseTextTheme = ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );

    return MaterialApp(
      title: 'CodexVault',
      themeMode: ThemeMode.dark,
      theme: ThemeData.from(colorScheme: colorScheme).copyWith(
        useMaterial3: true,
        textTheme: baseTextTheme,
        scaffoldBackgroundColor: colorScheme.background,
        menuBarTheme: const MenuBarThemeData(
          style: MenuStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFF1E1E1E)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    SearchFilterController.searchController.dispose();
    SearchFilterController.filterController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: const MenuBarWidget(),
    ),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth < 600 ? 8.0 : 16.0;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Material(
                  elevation: 2,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller:
                                  SearchFilterController.searchController,
                              onChanged: (value) =>
                                  debugPrint('Search updated: $value'),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: const Icon(Icons.search),
                                hintStyle: const TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller:
                                  SearchFilterController.filterController,
                              onChanged: (value) =>
                                  debugPrint('Filter updated: $value'),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Filter...',
                                prefixIcon: const Icon(Icons.filter_list),
                                hintStyle: const TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
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
                                    debugPrint(
                                        'Filter type selected: $newValue');
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
                child: ResizableNavigationPanel(
                  navigation: Container(
                    margin: EdgeInsets.all(horizontalPadding),
                    padding: EdgeInsets.all(horizontalPadding),
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
                                onTap: () =>
                                    GlobalState.selectedItemLabel.value =
                                        'Selected: Context Block A',
                              ),
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.description_outlined),
                                title: const Text('Context Block B'),
                                onTap: () =>
                                    GlobalState.selectedItemLabel.value =
                                        'Selected: Context Block B',
                              ),
                            ],
                          );
                        }
                        return ValueListenableBuilder<List<Conversation>>(
                          valueListenable: GlobalState.conversations,
                          builder: (context, conversations, _) {
                            return ValueListenableBuilder<List<Vault>>(
                              valueListenable: GlobalState.conversationVaults,
                              builder: (context, vaults, _) {
                                final showConvos =
                                    mode == ViewMode.all ||
                                        mode == ViewMode.raw ||
                                        mode == ViewMode.conversation;
                                final showVaults =
                                    mode == ViewMode.all ||
                                        mode == ViewMode.vault;
                                return ListView(
                                  children: [
                                    if (showConvos)
                                      if (conversations.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text('No conversations loaded'),
                                        )
                                      else ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Text(
                                            'Conversations',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ),
                                        for (final convo in conversations)
                                          ListTile(
                                            dense: true,
                                            leading: const Icon(
                                                Icons.chat_bubble_outline),
                                            title: Text(convo.title),
                                            subtitle: Text(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(convo.timestamp)),
                                            onTap: () {
                                              GlobalState.selectedConversation
                                                  .value = convo;
                                              GlobalState.selectedItemLabel
                                                  .value =
                                                  'Selected: ${convo.title}';
                                            },
                                          ),
                                        if (showVaults && vaults.isNotEmpty)
                                          const Divider(),
                                      ],
                                    if (showVaults && vaults.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(
                                          'Vaults',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ),
                                      for (final vault in vaults)
                                        ExpansionTile(
                                          leading: const Icon(Icons.folder),
                                          title: Text(
                                            vault.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          tilePadding: const EdgeInsets
                                              .symmetric(
                                                  horizontal: 8,
                                                  vertical: 4),
                                          onExpansionChanged: (expanded) {
                                            if (expanded) {
                                              GlobalState
                                                      .selectedItemLabel.value =
                                                  'Selected: ${vault.name}';
                                            }
                                          },
                                          children: [
                                            for (final convo in vault
                                                .conversations)
                                              ValueListenableBuilder<String?>(
                                                valueListenable: GlobalState
                                                    .hoveredConversationTitle,
                                                builder:
                                                    (context, hovered, child) {
                                                  final isHovered =
                                                      hovered == convo.title;
                                                  return MouseRegion(
                                                    cursor:
                                                        SystemMouseCursors.click,
                                                    onEnter: (_) {
                                                      GlobalState
                                                          .hoveredConversationTitle
                                                          .value = convo.title;
                                                    },
                                                    onExit: (_) {
                                                      if (GlobalState
                                                              .hoveredConversationTitle
                                                              .value ==
                                                          convo.title) {
                                                        GlobalState
                                                            .hoveredConversationTitle
                                                            .value = null;
                                                      }
                                                    },
                                                    child: ListTile(
                                                      dense: true,
                                                      leading: const Icon(Icons
                                                          .chat_bubble_outline),
                                                      title: Text(
                                                        convo.title,
                                                        style: isHovered
                                                            ? Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)
                                                            : null,
                                                      ),
                                                      subtitle: Text(
                                                          DateFormat(
                                                                  'yyyy-MM-dd HH:mm')
                                                              .format(convo
                                                                  .timestamp)),
                                                      trailing: const Icon(
                                                          Icons.chevron_right),
                                                      tileColor: isHovered
                                                          ? Theme.of(context)
                                                              .hoverColor
                                                          : null,
                                                      onTap: () {
                                                        GlobalState
                                                                .selectedItemLabel
                                                                .value =
                                                            'Selected: ${convo.title}';
                                                        GlobalState
                                                                .selectedConversation
                                                                .value =
                                                            convo;
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                    ],
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  content: Container(
                    margin: EdgeInsets.all(horizontalPadding),
                    padding: EdgeInsets.all(horizontalPadding),
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
                          color: Theme.of(context).colorScheme.surface,
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
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(convo.timestamp),
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var i = 0;
                                            i < convo.exchanges.length;
                                            i++) ...[
                                          messageCard(
                                              context,
                                              Icons.person,
                                              convo.exchanges[i].prompt),
                                          const SizedBox(height: 8),
                                          messageCard(
                                              context,
                                              Icons.smart_toy,
                                              convo.exchanges[i].response),
                                          if (i !=
                                              convo.exchanges.length - 1)
                                            const Divider(),
                                        ],
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
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                            style:
                                Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const VerticalDivider(width: 1),
                      const SizedBox(width: 12),
                      ValueListenableBuilder<int>(
                        valueListenable:
                            GlobalState.conversationCount,
                        builder: (context, count, child) {
                          return Text(
                            'Conversations: $count',
                            style:
                                Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const VerticalDivider(width: 1),
                      const SizedBox(width: 12),
                      ValueListenableBuilder<String>(
                        valueListenable:
                            GlobalState.selectedItemLabel,
                        builder: (context, label, child) {
                          return Text(
                            label,
                            style:
                                Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

}

Widget messageCard(BuildContext context, IconData icon, String text) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    color: Theme.of(context).colorScheme.surface,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    ),
  );
}

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: MenuStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
      ),
      children: [
        SubmenuButton(
          menuChildren: [
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(Icons.insert_drive_file),
              onPressed: () => MenuRouter.handle(context, MenuActions.openJson),
              child: const Text('Json'),
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.insert_drive_file),
              onPressed: () =>
                  MenuRouter.handle(context, MenuActions.openRawJson),
              child: const Text('Raw JSON'),
            ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.lock_open),
                  onPressed: () => MenuRouter.handle(context, MenuActions.openVault),
                  child: const Text('Vault'),
                ),
              ],
              child: const Text('Open'),
            ),
            SubmenuButton(
              leadingIcon: const Icon(Icons.file_upload),
              menuChildren: [
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(context, MenuActions.exportPlaceholder1),
                  child: const Text('Placeholder1'),
                ),
                MenuItemButton(
                  onPressed: () =>
                      MenuRouter.handle(context, MenuActions.exportPlaceholder2),
                  child: const Text('Placeholder2'),
                ),
              ],
              child: const Text('Export'),
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.exit_to_app),
              onPressed: () => MenuRouter.handle(context, MenuActions.exitApp),
              child: const Text('Exit'),
            ),
          ],
          child: const Text('File'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () => MenuRouter.handle(context, MenuActions.viewAll),
              child: const Text('All'),
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.view_list),
              onPressed: () => MenuRouter.handle(context, MenuActions.viewContext),
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
                  leadingIcon: const Icon(Icons.smart_toy),
                  onPressed: () =>
                  MenuRouter.handle(context, MenuActions.selectModelGpt),
                  child: const Text('GPT 3.5-turbo'),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.memory),
                  onPressed: () =>
                  MenuRouter.handle(context, MenuActions.selectModelGemini),
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
