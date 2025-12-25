import 'session_model.dart';

class SessionService {
  static final List<Session> _sessions = [];

  static List<Session> get sessions => _sessions;

  static void addSession(int minutes) {
    _sessions.add(
      Session(
        minutes: minutes,
        timestamp: DateTime.now(),
      ),
    );
  }
}