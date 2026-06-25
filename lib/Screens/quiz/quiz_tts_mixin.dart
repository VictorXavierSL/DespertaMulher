import 'package:flutter_tts/flutter_tts.dart';
import '../../models/question.dart';
import '../../common/risk_level.dart';

mixin QuizTtsMixin {
  final FlutterTts _tts = FlutterTts();
  bool _ttsReady = false;

  /// Chame no initState() da sua State.
  Future<void> initTts() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(2.0);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _ttsReady = true;
  }

  /// Chame no dispose() da sua State.
  Future<void> disposeTts() async {
    await _tts.stop();
  }

  /// Para qualquer leitura em andamento.
  Future<void> stopReading() async {
    if (_ttsReady) await _tts.stop();
  }

  /// Lê as perguntas de uma página do quiz.
  /// [questionOffset] = número da primeira pergunta na página (base 1).
  /// [totalQuestions] = total geral de perguntas do quiz.
  Future<void> readPage({
    required List<Question> questions,
    required int questionOffset,
    required int totalQuestions,
    required int pageNumber,
    required int lastPage,
    required int currentScore,
  }) async {
    if (!_ttsReady || questions.isEmpty) return;

    await _tts.stop();

    final buffer = StringBuffer();

    buffer.write('Página $pageNumber de $lastPage. ');

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final num = questionOffset + i + 1;

      buffer.write('Pergunta $num de $totalQuestions. ');
      buffer.write('${q.title}. ');

      if (q.multipleChoice) {
        buffer.write('Você pode marcar mais de uma opção. ');
      }

      buffer.write('As opções são: ');
      for (int j = 0; j < q.answers.length; j++) {
        final letter = String.fromCharCode(65 + j); // A, B, C...
        buffer.write('$letter: ${q.answers[j].title}. ');
      }

      buffer.write(' '); // pausa entre perguntas
    }

    // Na última página, lê também a indicação de risco atual
    if (pageNumber == lastPage) {
      final level = riskLevelFor(currentScore);
      final theme = RiskTheme.of(level);
      buffer.write(
        'Avaliação de risco atual: ${_stripEmoji(theme.label)}. '
            '${theme.description} '
            'Fim do questionário.',
      );
    }

    await _tts.speak(buffer.toString());
  }

  /// Remove emojis para soarem melhor no TTS.
  String _stripEmoji(String text) =>
      text.replaceAll(RegExp(r'[^\x00-\x7FÀ-ÿ\s]'), '').trim();
}