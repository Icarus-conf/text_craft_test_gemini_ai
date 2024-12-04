import 'package:flutter/material.dart';
import 'package:text_craft_test_gemini_ai/services/api_key.dart';
import 'package:text_craft_test_gemini_ai/services/gemini_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final TextEditingController _textController = TextEditingController();
  String _enhancedText = '';
  bool _isLoading = false;
  String _tone = 'Professional';

  final GeminiService _geminiService = GeminiService(apiKey: apiKey);

  // Enhance the input text using GeminiService
  Future<void> _enhanceText() async {
    if (_textController.text.trim().isEmpty) {
      _showSnackbar("Please enter text to analyze");
      return;
    }

    setState(() {
      _isLoading = true;
      _enhancedText = '';
    });

    try {
      final userInput = _textController.text.trim();
      final enhancedText = await _geminiService.enhanceText(userInput, _tone);

      setState(() {
        _enhancedText = enhancedText;
      });
    } catch (e) {
      _showSnackbar("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show snackbar messages
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Build tone selector dropdown
  Widget _buildToneSelector() {
    return DropdownButton<String>(
      value: _tone,
      items: ['Professional', 'Creative', 'Simplified']
          .map((tone) => DropdownMenuItem(value: tone, child: Text(tone)))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          _tone = newValue!;
        });
      },
    );
  }

  // Detect text direction (RTL or LTR)
  TextDirection _getTextDirection(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Enhancer with Gemini"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextInput(),
            const SizedBox(height: 16),
            _buildToneSelectorRow(),
            const SizedBox(height: 16),
            _buildEnhanceButton(),
            const SizedBox(height: 16),
            if (_enhancedText.isNotEmpty) _buildEnhancedText(),
          ],
        ),
      ),
    );
  }

  // Text input field
  Widget _buildTextInput() {
    return TextField(
      controller: _textController,
      maxLines: 5,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter your text here...",
      ),
    );
  }

  // Tone selection row
  Widget _buildToneSelectorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Select Tone:", style: TextStyle(fontSize: 16)),
        _buildToneSelector(),
      ],
    );
  }

  // Enhance button
  Widget _buildEnhanceButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _enhanceText,
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("Enhance Text"),
    );
  }

  // Display the enhanced text
  Widget _buildEnhancedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enhanced Text:"),
        const SizedBox(height: 8),
        Directionality(
          textDirection: _getTextDirection(_enhancedText),
          child: Text(
            _enhancedText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
