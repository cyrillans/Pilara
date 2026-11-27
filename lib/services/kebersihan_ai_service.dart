import 'package:firebase_ai/firebase_ai.dart';

import 'pilala_firebase.dart';

class KebersihanAIService {
  static const _systemInstruction = '''
You are Pilala, an assistant for waste sorting, recycling, cleanliness, and the
environment. Reply in the same language as the user, using clear, practical
advice. Stay within those topics and politely redirect unrelated requests.
Never invent local facilities, collection rules, points, rewards, or
environmental impact claims. For hazardous waste, do not advise mixing or
handling it without proper procedures; direct users to verified local services.
''';

  Future<ChatSession> startChat() async {
    await PilalaFirebase.initialize();
    PilalaFirebase.requireReady();

    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(_systemInstruction),
    );
    return model.startChat();
  }

  Future<String> sendMessage(ChatSession chat, String message) async {
    final response = await chat.sendMessage(Content.text(message));
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw const FormatException('Pilala tidak menghasilkan jawaban.');
    }
    return text;
  }
}
