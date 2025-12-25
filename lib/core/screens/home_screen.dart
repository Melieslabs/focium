import 'package:flutter/material.dart';
import 'package:focium/core/screens/chatbot.dart';
import 'package:focium/core/screens/pomodoro_screen.dart';
import 'package:focium/core/screens/session_tracker_screen.dart';
import 'package:focium/core/screens/settings_screen.dart';
import 'package:focium/core/screens/tasks_screen.dart';
import 'package:focium/core/features/utils/session_model.dart';

void main() => runApp(const FociumHome());

class FociumHome extends StatelessWidget {
  const FociumHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData.dark(), // Dark UI
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A), // top dark grey
              Color.fromARGB(255, 116, 114, 114), // top dark grey
              Color(0xFF0F0F0F), // bottom near-black
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Top bar: menu + chatbot button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu icon container
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },

                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.menu, size: 22),
                      ),
                    ),

                    // Chatbot button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "ChatBot",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Header text
                const Text(
                  "Focus, build momentum,\nbe in Control",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                // Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white70),
                      SizedBox(width: 10),
                      Text(
                        "Search...",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Feature cards
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PomodoroScreen(),
                            ),
                          );
                        },
                        child: FeatureCard(title: "Focus\ncoach"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TasksScreen(),
                            ),
                          );
                        },
                        child: FeatureCard(title: "Task\ngenerator"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionTrackerScreen(
                            sessions: [
                              Session(minutes: 25, timestamp: DateTime.now()),
                              Session(
                                minutes: 40,
                                timestamp: DateTime.now().subtract(Duration(hours: 1)),
                              ),
                            ],
                          ),
                        ),
                      );

                        },
                        child: FeatureCard(title: "Session\ntracker")),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // History header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Recent Sessions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text("See all", style: TextStyle(color: Colors.white)),
                  ],
                ),

                const SizedBox(height: 10),

                // History items
                const Expanded(child: HistoryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Feature Card Widget ----
class FeatureCard extends StatelessWidget {
  final String title;
  const FeatureCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.arrow_outward),
          ),
        ],
      ),
    );
  }
}

// ---- History List ----
class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ("AI Focus Coach", "How to stay focused"),
      ("Task Generator", "Break goals into steps"),
      ("Session Tracker", "See your progress"),
      ("Insight Writer", "Daily productivity tips"),
    ];

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[i].$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    items[i].$2,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        );
      },
    );
  }
}