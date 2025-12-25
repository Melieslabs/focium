import 'package:flutter/material.dart';
import 'package:focium/core/screens/chatbot_personality.dart';
import 'package:lottie/lottie.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:focium/models/tasks.dart';

class AppColors {
  static const bg = Color(0xFF0F0F0F);
  static const card = Color(0xFF1E1E1E);
  static const grey = Color(0xFF414141);
  static const lightGreyText = Color(0xFF787878);
  static const whiteSoft = Color(0xFFD9D9D9);
}

class ChatPage extends StatefulWidget {
  final String? initialPrompt;
  const ChatPage({super.key, this.initialPrompt});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Box<Task> taskBox;
  late Box chatBox;

  List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Assign opened boxes
    taskBox = Hive.box<Task>('tasks');
    chatBox = Hive.box('chat');

    // Load previous messages
    final savedMessages = chatBox.get('messages');
if (savedMessages != null) {
  messages = (savedMessages as List)
      .map((m) => Map<String, dynamic>.from(m as Map))
      .toList();
}

    // Add initial prompt if provided
    if (widget.initialPrompt != null) {
      messages.add({"role": "user", "text": widget.initialPrompt!});
      messages.add({
        "role": "bot",
        "text":
            "Sure, let’s work on that. Tell me what you want to focus on right now.",
      });
      _saveMessages();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _saveMessages() {
    chatBox.put('messages', messages);
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      messages.add({"role": "user", "text": text});

      List<String>? tasks;

      // Keyword-based task generation
      if (text.toLowerCase().contains("morning") ||
          text.toLowerCase().contains("plan my day") ||
          text.toLowerCase().contains("focus")) {
        tasks = [
          "Drink water",
          "Stretch for 10 minutes",
          "Check emails",
          "Start focus session"
        ];
      } else if (text.toLowerCase().contains("study") ||
          text.toLowerCase().contains("exam")) {
        tasks = [
          "Review notes",
          "Practice past questions",
          "Take short breaks",
          "Summarize key points"
        ];
      } else if (text.toLowerCase().contains("workout") ||
          text.toLowerCase().contains("exercise")) {
        tasks = [
          "Warm-up stretches",
          "Cardio for 20 minutes",
          "Strength training",
          "Cool down & hydrate"
        ];
      }

      if (tasks != null) {
        // Add tasks to Hive
        for (var taskTitle in tasks) {
          final task = Task(title: taskTitle, isDone: false);
          taskBox.add(task);
        }

        // Add bot message with tasks
        messages.add({"role": "bot_tasks", "tasks": tasks});
      } else {
        // Default bot reply
        messages.add({
          "role": "bot",
          "text": "Got it! Here’s a simple suggestion based on your message."
        });
      }

      _saveMessages();
      _scrollToBottom();
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatbotPersonality()),
                );
              },
              child: Icon(Icons.circle_outlined, size: 30, color: Colors.grey),
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          "Focium Chat",
          style: TextStyle(
            color: AppColors.whiteSoft,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Lottie wave
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Lottie.asset(
                'assets/animations/wave.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Messages list
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];

                if (msg["role"] == "user" || msg["role"] == "bot") {
                  final isUser = msg["role"] == "user";
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.grey : AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg["text"] ?? "",
                        style: const TextStyle(color: AppColors.whiteSoft),
                      ),
                    ),
                  );
                }

                if (msg["role"] == "bot_tasks") {
                  final tasksDynamic = msg["tasks"];
                  if (tasksDynamic == null) return const SizedBox.shrink();
                  final List<String> tasks = List<String>.from(tasksDynamic);

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasks.map((taskTitle) {
                          final task = taskBox.values.firstWhere(
                            (t) => t.title == taskTitle,
                            orElse: () => Task(title: taskTitle),
                          );

                          return StatefulBuilder(
                              builder: (context, setStateSB) {
                            return CheckboxListTile(
                              value: task.isDone,
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  color: task.isDone
                                      ? Colors.greenAccent
                                      : AppColors.whiteSoft,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              activeColor: Colors.greenAccent,
                              onChanged: (v) {
                                setStateSB(() {
                                  task.isDone = v ?? false;
                                  if (task.isInBox) task.save();
                                });
                              },
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          // Input area
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: AppColors.card,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: AppColors.whiteSoft),
                        decoration: const InputDecoration(
                          hintText: "Send a message...",
                          hintStyle: TextStyle(color: AppColors.lightGreyText),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mic, color: AppColors.whiteSoft),
                    ),
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: AppColors.whiteSoft),
                    ),
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
