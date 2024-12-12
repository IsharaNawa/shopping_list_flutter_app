import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/add_new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> groceryItems = [];

  void addNewItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const AddNewItemScreen(),
      ),
    );
    setState(() {
      groceryItems.add(newItem!);
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
