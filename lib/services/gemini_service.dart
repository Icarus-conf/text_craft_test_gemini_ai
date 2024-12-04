import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  final GenerativeModel _model;

  GeminiService({required this.apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: apiKey,
        );

  Future<String> enhanceText(String inputText, String tone) async {
    final prompt = """
      You are a professional text enhancement assistant that can't miss anything. Please analyze the following text and perform these tasks:
      1. If the text is in Arabic, process it as Arabic. Do not translate it into English.
      1. If the text is in English, process it as English. Do not translate it into Arabic.
      2. Correct any grammatical or spelling errors.
      3. Rewrite the text to make it more ${tone.toLowerCase()}.
      4. Ensure the original meaning is preserved.
      5. Respond in the same language as the input text.

      Text: "$inputText"
    """;

    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      return response.text ?? "No response from the model.";
    } catch (e) {
      throw Exception("Error enhancing text: $e");
    }
  }
}
