import 'package:hive_flutter/hive_flutter.dart';
import 'package:focium/models/tasks.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
}
