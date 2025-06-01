import 'package:flutter/material.dart';

// --- Pasha Bank colors ---
const kPashaGreen = Color(0xFF198754);
const kPashaRed = Color(0xFFDA2032);
const kPashaBackground = Color(0xFFF7F9F9);

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  List<Map<String, dynamic>> _goals = [
    {'name': 'New Bicycle', 'amount': 100},
  ];
  double saved = 36;

  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Savings Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Goal Name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Target Amount (₼)",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPashaGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final amt = double.tryParse(amountController.text.trim());
                if (name.isNotEmpty && amt != null && amt > 0) {
                  setState(() {
                    _goals.add({'name': name, 'amount': amt});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Savings"),
        backgroundColor: kPashaGreen,
        foregroundColor: Colors.white,
      ),
      backgroundColor: kPashaBackground,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PARENT SECTION (locked/info)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kPashaGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: kPashaGreen, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Parent Section",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kPashaGreen,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Parents can send money here to help you save for your future. Ask your parent to use their Pasha parent app to guarantee your savings goals!",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "For parents only",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // CHILDREN SECTION
            const Text(
              "Your Savings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: kPashaGreen,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total saved:",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "${saved.toInt()} ₼",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: kPashaGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: _goals.isNotEmpty
                        ? (saved / _goals[0]['amount'])
                        : 0,
                    backgroundColor: kPashaGreen.withOpacity(0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPashaGreen,
                    ),
                    minHeight: 7,
                  ),
                  const SizedBox(height: 18),
                  // List of savings goals
                  ..._goals.map(
                    (goal) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: kPashaRed, size: 26),
                          const SizedBox(width: 10),
                          Text(
                            "Goal: ${goal['name']} - ${goal['amount']} ₼",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPashaGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                  minimumSize: const Size(260, 48),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  "Add New Savings Goal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () => _showAddGoalDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
