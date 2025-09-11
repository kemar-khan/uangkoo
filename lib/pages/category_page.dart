import 'package:drift/drift.dart' hide Column; // ✅ Hide Drift's Column
import 'package:flutter/material.dart'; // ✅ Use Flutter's Column
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
  final TextEditingController _nameController = TextEditingController();

  Future insert(String name, int type) async {
    try {
      final row = await database
          .into(database.categories)
          .insertReturning(
            CategoriesCompanion(name: Value(name), type: Value(type)),
          );
      print('Inserted: $row');
    } catch (e) {
      print('Insert error: $e');

      // Fallback method
      try {
        final id = await database
            .into(database.categories)
            .insert(CategoriesCompanion(name: Value(name), type: Value(type)));
        print('Inserted with ID: $id');
      } catch (e2) {
        print('Fallback insert error: $e2');
      }
    }
  }

  void openDialog() {
    _nameController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            // ✅ Now this will use Flutter's Column
            mainAxisSize: MainAxisSize.min,
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
                controller: _nameController,
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
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    await insert(_nameController.text, isExpense ? 2 : 1);
                    Navigator.of(context).pop();
                    setState(() {});
                  }
                },
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
  void dispose() {
    _nameController.dispose();
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        // ✅ This will now work correctly
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
                IconButton(onPressed: openDialog, icon: const Icon(Icons.add)),
              ],
            ),
          ),

          // Dynamic categories from database
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: database.select(database.categories).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final categories = snapshot.data ?? [];

                if (categories.isEmpty) {
                  return const Center(child: Text('No categories yet'));
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isExpenseCategory = category.type == 2;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading: isExpenseCategory
                              ? const Icon(Icons.upload, color: Colors.red)
                              : const Icon(Icons.download, color: Colors.green),
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await database.delete(database.categories)
                                    ..where((c) => c.id.equals(category.id))
                                    ..go();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
