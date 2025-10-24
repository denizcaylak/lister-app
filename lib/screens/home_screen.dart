import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/list_model.dart';
import '../widgets/side_menu.dart';
import '../widgets/list_tile_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _newItemCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ListsProvider>(
      builder: (context, provider, _) {
        final selected = provider.selectedList;
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: Text(selected ?? 'No list selected'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: selected == null
                    ? null
                    : () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete list'),
                            content: Text(
                              'Delete "$selected" and all its items?',
                            ),
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
                        if (ok == true) provider.removeList(selected);
                      },
              ),
            ],
          ),
          drawer: const SideMenu(),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                selected == null ? _noListView(provider) : _listView(provider),
          ),
          floatingActionButton: selected == null
              ? null
              : FloatingActionButton(
                  onPressed: () => _showAddItemDialog(provider),
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }

  Widget _noListView(ListsProvider provider) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add a list'),
        onPressed: () => _showAddListDialog(provider),
      ),
    );
  }

  Widget _listView(ListsProvider provider) {
    final items = provider.selectedItems;

    if (items.isEmpty) {
      // Liste boşsa sadece ortada "No items yet." göster
      return Center(
        child: const Text(
          'No items yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
            color: Colors.red,
          ),
          onDismissed: (_) => provider.removeItem(item.id),
          child: ListTileItem(
              item: item, onToggle: () => provider.toggleItem(item.id)),
        );
      },
    );
  }

  void _showAddListDialog(ListsProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New list'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'List name'),
          onSubmitted: (_) => _saveList(provider, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _saveList(provider, controller),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveList(ListsProvider provider, TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    provider.addList(text);
    Navigator.pop(context);
  }

  void _showAddItemDialog(ListsProvider provider) {
    _newItemCtrl.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New item'),
        content: TextField(
          controller: _newItemCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'What to do?'),
          onSubmitted: (_) => _saveItem(provider),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _saveItem(provider),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveItem(ListsProvider provider) {
    final text = _newItemCtrl.text.trim();
    if (text.isEmpty) return;
    provider.addItemToSelected(text);
    Navigator.pop(context);
  }
}
