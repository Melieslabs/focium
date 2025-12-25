import 'package:hive/hive.dart';
import '../models/tasks.dart';

class TaskService {
  static const String boxName = 'tasksBox';

  // Open the box
  Future<Box<Task>> openBox() async {
    return await Hive.openBox<Task>(boxName);
  }

  // Load all tasks
  Future<List<Task>> getTasks() async {
    final box = await openBox();
    return box.values.toList();
  }

  // Add a task
  Future<void> addTask(String title) async {
    final box = await openBox();
    final task = Task(title: title, isDone: false);
    await box.add(task);
  }

  // Toggle completion
  Future<void> toggleTask(int index) async {
    final box = await openBox();
    final task = box.getAt(index);
    if (task == null) return;

    task.isDone = !task.isDone;
    await task.save();
  }

  // Delete task
  Future<void> deleteTask(int index) async {
    final box = await openBox();
    await box.deleteAt(index);
  }
}
