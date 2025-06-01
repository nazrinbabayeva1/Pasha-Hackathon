import 'package:flutter/material.dart';

// --- Pasha Bank Colors ---
const kPashaGreen = Color(0xFF198754);
const kPashaRed = Color(0xFFDA2032);
const kPashaOrange = Color(0xFFF2994A);
const kPashaBg = Color(0xFFF7F9F9);

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Example tasks list
  List<Task> tasks = [
    Task("Clean your room", "Tidy up and organize your room.", 3),
    Task("Finish homework", "Complete your math and science homework.", 2),
    Task("Help set the table", "Help to set up the dinner table.", 1),
    Task("Read 20 pages", "Read from your favorite book.", 2),
  ];

  void _onTaskChecked(int index) {
    setState(() {
      if (tasks[index].status == TaskStatus.assigned) {
        tasks[index].status = TaskStatus.pending;
      }
    });
    // Here, you might send a request to the parent app/server.
    // But in this demo, we only change the status locally.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: kPashaGreen,
        foregroundColor: Colors.white,
      ),
      backgroundColor: kPashaBg,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          final task = tasks[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: kPashaGreen,
                child: Text(
                  "${task.reward}₼",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.description),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (task.status == TaskStatus.assigned)
                        Checkbox(
                          value: false,
                          onChanged: (_) => _onTaskChecked(i),
                          activeColor: kPashaGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      if (task.status == TaskStatus.pending)
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: null, // Disabled
                              activeColor: kPashaGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: kPashaOrange.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Pending approval",
                                style: TextStyle(
                                  color: kPashaOrange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              trailing: (task.status == TaskStatus.pending)
                  ? Icon(Icons.hourglass_top, color: kPashaOrange)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

enum TaskStatus { assigned, pending }

class Task {
  final String title;
  final String description;
  final int reward;
  TaskStatus status;
  Task(
    this.title,
    this.description,
    this.reward, [
    this.status = TaskStatus.assigned,
  ]);
}
