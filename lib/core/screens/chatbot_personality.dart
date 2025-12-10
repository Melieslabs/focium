import 'package:flutter/material.dart';

class ChatbotPersonality extends StatefulWidget {
  const ChatbotPersonality({super.key});

  @override
  State<ChatbotPersonality> createState() => _ChatbotPersonalityState();
}

class _ChatbotPersonalityState extends State<ChatbotPersonality> {
  String chatbotPersonality = "Standard";

  void _selectPersonality() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F0F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chatbot Personality",
                style: TextStyle(
                    color: Color(0xFFD9D9D9),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _personalityOption("Standard"),
              _personalityOption("Supportive"),
              _personalityOption("Strict / Discipline Mode"),
            ],
          ),
        );
      },
    );
  }

  Widget _personalityOption(String mode) {
    return ListTile(
      title: Text(
        mode,
        style: const TextStyle(color: Color(0xFFD9D9D9)),
      ),
      trailing: chatbotPersonality == mode
          ? const Icon(Icons.check, color: Color(0xFFD9D9D9))
          : null,
      onTap: () {
        setState(() => chatbotPersonality = mode);
        Navigator.pop(context);
      },
    );
  }

  Widget _settingsTile({
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFFD9D9D9)),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Color(0xFF777777)))
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Color(0xFFD9D9D9),
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _settingsTile(
            title: "Chatbot Personality",
            subtitle: chatbotPersonality,
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFD9D9D9)),
            onTap: _selectPersonality,
          ),
        ],
      ),
    );
  }
}
