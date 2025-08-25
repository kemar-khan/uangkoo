import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.montserrat();

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _summaryBox(
                      Icons.download,
                      Colors.green,
                      "Income",
                      "RM 5000",
                    ),
                    const Spacer(),
                    _summaryBox(Icons.upload, Colors.red, "Expense", "RM 2000"),
                  ],
                ),
              ),
            ),

            // Transactions title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Transactions",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Transactions List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  TransactionTile(
                    amount: "RM 2000",
                    description: "Beli baju loro piana old money",
                    icon: Icons.upload,
                    iconColor: Colors.red,
                  ),
                  SizedBox(height: 10),
                  TransactionTile(
                    amount: "RM 800",
                    description: "Duit mara",
                    icon: Icons.download,
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox(IconData icon, Color color, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(value, style: GoogleFonts.montserrat(fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String amount;
  final String description;
  final IconData icon;
  final Color iconColor;

  const TransactionTile({
    super.key,
    required this.amount,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.delete),
            SizedBox(width: 10),
            Icon(Icons.edit_note_outlined),
          ],
        ),
        title: Text(
          amount,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description, style: GoogleFonts.montserrat()),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
