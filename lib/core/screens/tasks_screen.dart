import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:focium/models/tasks.dart';// <-- added model import

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();

    // Safety: ensure box exists before accessing
    if (!Hive.isBoxOpen('tasks')) {
      taskBox = Hive.box<Task>('tasks');
    } else {
      taskBox = Hive.box<Task>('tasks');
    }
  }

  /// Adds task to Hive
  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    taskBox.add(Task(title: title.trim()));
  }

  /// Removes task from Hive
  void _removeTask(int index) {
    if (index < 0 || index >= taskBox.length) return; // safety
    taskBox.deleteAt(index);
  }

  /// Toggles task completion
  void _toggleTask(int index) {
    if (index < 0 || index >= taskBox.length) return; // safety

    final task = taskBox.getAt(index);
    if (task == null) return;

    task.isDone = !task.isDone;
    task.save(); // updates Hive
  }

  /// Bottom modal for adding task
  void _showAddTaskModal() {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F0F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New Task",
                style: TextStyle(
                  color: Color(0xFFD9D9D9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your task...",
                  hintStyle: const TextStyle(color: Color(0xFF777777)),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addTask(controller.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          "Today's Tasks",
          style: TextStyle(
            color: Color(0xFFD9D9D9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      /// LISTEN TO HIVE FOR LIVE UPDATES
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No tasks yet. Stay sharp.",
                style: TextStyle(color: Color(0xFF777777), fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index);

              if (task == null) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      task.isDone
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: task.isDone
                          ? const Color(0xFFD9D9D9)
                          : const Color(0xFF777777),
                    ),
                    onPressed: () => _toggleTask(index),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: const Color(0xFFD9D9D9),
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF777777)),
                    onPressed: () => _removeTask(index),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9D9D9),
        onPressed: _showAddTaskModal,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
