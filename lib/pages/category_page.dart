import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangkoo/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  final AppDatabase database = AppDatabase();
  final now = DateTime.now();

  Future insert(String name, int type) async {
    final row = await database
        .into(database.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: Value(type),
            createdAt: Value(now),
            deletedAt: Value(now),
          ),
        );
    print(row);
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min, // keeps dialog compact
            children: [
              Text(
                (isExpense) ? "Add Expense" : "Add Income",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: (isExpense) ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Name",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isExpense) ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpense,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                  onPressed: openDialog, // ✅ Now opens your dialog
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Card 1
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: (isExpense)
                    ? const Icon(Icons.upload, color: Colors.red)
                    : const Icon(Icons.download, color: Colors.green),
                title: const Text('Sedekah'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),

          // Card 2
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: (isExpense)
                    ? const Icon(Icons.upload, color: Colors.red)
                    : const Icon(Icons.download, color: Colors.green),
                title: const Text('Gas Money'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),

          // Card 3
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: (isExpense)
                    ? const Icon(Icons.upload, color: Colors.red)
                    : const Icon(Icons.download, color: Colors.green),
                title: const Text('Groceries'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
