import 'package:hive/hive.dart';

part 'tasks.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;
  

  @HiveField(1)
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
  });
}
