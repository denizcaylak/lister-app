import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/list_model.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final TextEditingController _newListCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lists',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _showAddList(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: _listsView()),
            const Divider(height: 1),
            _themeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _listsView() {
    return Consumer<ListsProvider>(
      builder: (context, provider, _) {
        final names = provider.lists.keys.toList();
        if (names.isEmpty) return const Center(child: Text('No lists yet'));
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final name = names[index];
            final selected = provider.selectedList == name;
            return ListTile(
              selected: selected,
              leading: const Icon(Icons.list_alt),
              title: Text(name),
              onTap: () {
                provider.selectList(name);
                Navigator.pop(context);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete list'),
                      content: Text('Delete "$name" and its items?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) provider.removeList(name);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeToggle() {
    return Consumer<ListsProvider>(
      builder: (context, provider, _) {
        final isDark = provider.themeMode == ThemeMode.dark ||
            (provider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return ListTile(
          leading: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
          title: Text(isDark ? 'Dark' : 'Light'),
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (_) => provider.toggleTheme(),
          ),
          onTap: () => provider.toggleTheme(),
        );
      },
    );
  }

  void _showAddList(BuildContext context) {
    _newListCtrl.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New list'),
        content: TextField(
          controller: _newListCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'List name'),
          onSubmitted: (_) => _save(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _save(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    final text = _newListCtrl.text.trim();
    if (text.isEmpty) return;
    Provider.of<ListsProvider>(context, listen: false).addList(text);
    Navigator.pop(context);
    Navigator.pop(context); // close drawer
  }
}
