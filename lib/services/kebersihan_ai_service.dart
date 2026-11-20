import 'package:firebase_ai/firebase_ai.dart';

import 'pilala_firebase.dart';

class KebersihanAIService {
  static const _systemInstruction = '''
Kamu adalah Pilala, asisten edukasi kebersihan, pengelolaan sampah, dan daur ulang.
Jawab dalam bahasa Indonesia dengan ramah, jelas, dan praktis.
Jawab hanya pertanyaan yang berkaitan dengan kebersihan, pengelolaan sampah,
daur ulang, dan lingkungan. Tolak dengan sopan permintaan di luar topik tersebut
dan arahkan kembali ke topik kebersihan. Untuk sampah B3 atau bahan berbahaya,
jangan menyarankan pengguna mencampur atau menanganinya tanpa prosedur; arahkan
ke fasilitas pengumpulan resmi setempat.
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
