import 'package:flutter/material.dart';
import 'package:focium/core/screens/splash_screen.dart';
import 'hive_setup.dart';
import 'package:hive/hive.dart';
import 'package:focium/models/tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  // Register adapters only if not registered
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskAdapter());
  }

  // Open boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('chat'); // generic box for chat messages

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
