import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/menu_item.dart';

class MenuProvider with ChangeNotifier {
  List<MenuItem> _items = [];
  List<String> _categories = ["Full Menu"];

  List<MenuItem> get items => _items;
  List<String> get categories => _categories;

  Future<void> loadMenuData() async {
    print('Loading menu data...');
    try {
      final String response =
          await rootBundle.loadString('assets/restaurant_menu.json');
      print('JSON response loaded');
      final List<dynamic> data = json.decode(response);
      print('JSON decoded');
      _items = data.map((item) => MenuItem.fromJson(item)).toList();
      _categories.addAll(_items.map((item) => item.category).toSet().toList());
      print('Data loaded successfully. Number of items: ${_items.length}');
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  List<MenuItem> searchMenu(String query) {
    if (query.isEmpty) {
      return _items;
    }
    if (int.tryParse(query) != null) {
      // If the query is a number, search by number
      return _items
          .where((item) => item.number.toString().startsWith(query))
          .toList();
    } else {
      // If the query is a string, search by name
      return _items
          .where((item) =>
              item.englishName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  List<MenuItem> filterByCategory(String category) {
    if (category == "Full Menu") {
      return _items;
    }
    return _items.where((item) => item.category == category).toList();
  }
}
