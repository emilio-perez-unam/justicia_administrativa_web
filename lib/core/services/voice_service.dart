import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isEnabled = false;

  Future<bool> initialize() async {
    if (!_isEnabled) {
      _isEnabled = await _speechToText.initialize();
    }
    return _isEnabled;
  }

  Future<void> startListening({required Function(String) onResult}) async {
    if (_isEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    }
  }

  Future<void> stopListening() async {
    if (_isEnabled) {
      await _speechToText.stop();
    }
  }

  bool get isListening => _speechToText.isListening;
}
