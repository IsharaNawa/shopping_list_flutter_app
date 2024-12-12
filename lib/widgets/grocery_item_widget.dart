import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: groceryItem.category.color,
          ),
          const SizedBox(
            width: 40,
          ),
          Text(
            groceryItem.name,
          ),
          const Spacer(),
          Text(
            groceryItem.quantity.toString(),
          ),
        ],
      ),
    );
  }
}
