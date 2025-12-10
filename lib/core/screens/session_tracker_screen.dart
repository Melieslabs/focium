import 'package:flutter/material.dart';
import 'package:focium/core/features/utils/session_model.dart';

class SessionTrackerScreen extends StatelessWidget {
  final List<Session> sessions;

  const SessionTrackerScreen({super.key, required this.sessions});

  int get totalMinutes =>
      sessions.fold(0, (sum, session) => sum + session.minutes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          "Session Tracker",
          style: TextStyle(
            color: Color(0xFFD9D9D9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Focus Time",
                    style: TextStyle(color: Color(0xFFD9D9D9), fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$totalMinutes min",
                    style: const TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Sessions",
              style: TextStyle(
                color: Color(0xFFD9D9D9),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: sessions.isEmpty
                  ? const Center(
                      child: Text(
                        "No sessions yet",
                        style: TextStyle(color: Color(0xFFB0B0B0)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF3A3A3A)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${session.minutes} minutes",
                                style: const TextStyle(
                                  color: Color(0xFFD9D9D9),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${session.timestamp.day}/${session.timestamp.month}/${session.timestamp.year}",
                                style: const TextStyle(
                                  color: Color(0xFF8C8C8C),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
