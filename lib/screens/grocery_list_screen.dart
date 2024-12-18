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
  bool isLoading = true;
  String? isError;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "shoppinglist-c7050-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping_list.json");

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          isError = "Failed to fetch data. Please try again later";
          return;
        });
      }

      if (json.decode(response.body) == null) {
        setState(() {
          isLoading = false;
        });
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = "Something went wrong! Please try again later!";
      });
    }
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

  void removeItem(GroceryItem groceryItem) async {
    int index = groceryItems.indexOf(groceryItem);

    setState(() {
      groceryItems.remove(groceryItem);
    });

    final url = Uri.https(
        "shoppinglist-c7050-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping_list/${groceryItem.id}.json");

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        setState(() {
          groceryItems.insert(index, groceryItem);
        });
      }
    } catch (e) {
      setState(() {
        groceryItems.insert(index, groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
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
    );

    if (groceryItems.isEmpty) {
      content = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "No Groceries have added yet!",
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (isError != null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isError!,
            ),
          ],
        ),
      );
    }

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
      body: content,
    );
  }
}
