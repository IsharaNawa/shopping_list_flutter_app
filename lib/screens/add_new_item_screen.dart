import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new item"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) => "",
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      initialValue: "1",
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: DropdownButtonFormField(
                    items: categories.entries
                        .map(
                          (index) => DropdownMenuItem(
                            value: index.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: index.value.color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(index.value.title)
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {},
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
