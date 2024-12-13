import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/add_new_item_screen.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "shoppinglist-c7050-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping_list.json");

    final response = await http.get(url);

    if (json.decode(response.body) == null) {
      return;
    }

    Map<String, dynamic> items = json.decode(response.body);

    List<GroceryItem> loadedGroceryItems = [];

    for (final entry in items.entries) {
      final category_ = categories.entries.firstWhere(
          (catItem) => catItem.value.title == entry.value["category"]);

      loadedGroceryItems.add(
        GroceryItem(
          id: entry.key,
          name: entry.value["name"],
          quantity: entry.value["quantity"],
          category: Category(category_.value.title, category_.value.color),
        ),
      );
    }

    setState(() {
      groceryItems = loadedGroceryItems;
    });
  }

  void addNewItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const AddNewItemScreen(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      groceryItems.add(newItem);
    });
  }

  void removeItem(GroceryItem groceryItem) {
    setState(() {
      groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your groceries"),
        actions: [
          IconButton(
            onPressed: addNewItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: groceryItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "No Groceries have added yet!",
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(groceryItems[index].id),
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: groceryItems[index].category.color,
                  ),
                  title: Text(groceryItems[index].name),
                  trailing: Text(
                    groceryItems[index].quantity.toString(),
                  ),
                ),
                onDismissed: (direction) {
                  removeItem(groceryItems[index]);
                },
              ),
            ),
    );
  }
}
