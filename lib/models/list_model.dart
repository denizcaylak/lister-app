import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_item.dart';

class ListsProvider extends ChangeNotifier {
  // Map<listName, items>
  final Map<String, List<ListItem>> _lists = {};
  String? _selectedList;
  ThemeMode _themeMode = ThemeMode.system;

  Map<String, List<ListItem>> get lists => _lists;
  String? get selectedList => _selectedList;
  ThemeMode get themeMode => _themeMode;

  List<ListItem> get selectedItems => _lists[_selectedList] ?? [];

  // ------------------- Load Preferences -------------------
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLists = prefs.getString('lister_lists');
    final savedSelected = prefs.getString('lister_selected');
    final savedTheme = prefs.getString('lister_theme');

    if (savedLists != null) {
      final Map decoded = jsonDecode(savedLists) as Map;
      decoded.forEach((key, value) {
        final items = (value as List)
            .map((e) => ListItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _lists[key as String] = items;
      });
    }

    if (savedSelected != null) _selectedList = savedSelected;

    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    notifyListeners();
  }

  // ------------------- Save Preferences -------------------
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final mapToSave = _lists.map(
      (k, v) => MapEntry(k, v.map((e) => e.toJson()).toList()),
    );
    await prefs.setString('lister_lists', jsonEncode(mapToSave));
    if (_selectedList != null) {
      await prefs.setString('lister_selected', _selectedList!);
    } else {
      await prefs.remove('lister_selected');
    }
    await prefs.setString('lister_theme', _themeMode.toString());
  }

  // ------------------- List Actions -------------------
  Future<void> addList(String name) async {
    if (name.trim().isEmpty) return;
    if (_lists.containsKey(name)) return;
    _lists[name] = [];
    _selectedList = name;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> removeList(String name) async {
    _lists.remove(name);
    if (_selectedList == name) _selectedList = null;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> selectList(String? name) async {
    if (name != null && _lists.containsKey(name)) {
      _selectedList = name;
    } else {
      _selectedList = null;
    }
    await _savePreferences();
    notifyListeners();
  }

  Future<void> removeSelectedListCompletely() async {
    if (_selectedList == null) return;
    await removeList(_selectedList!);
  }

  // ------------------- Item Actions -------------------
  Future<void> addItemToSelected(String text) async {
    if (_selectedList == null) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _lists[_selectedList]!.insert(0, ListItem(id: id, text: text));
    await _savePreferences();
    notifyListeners();
  }

  Future<void> toggleItem(String id) async {
    final items = selectedItems;
    final idx = items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    items[idx].completed = !items[idx].completed;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    final items = selectedItems;
    items.removeWhere((e) => e.id == id);
    await _savePreferences();
    notifyListeners();
  }

  // ------------------- Theme -------------------
  Future<void> toggleTheme() async {
    _themeMode =
        (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await _savePreferences();
    notifyListeners();
  }
}
