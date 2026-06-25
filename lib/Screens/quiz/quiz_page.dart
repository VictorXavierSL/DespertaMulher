import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/app_routes.dart';
import '../../models/question.dart';
import '../app_header.dart';
import 'question_widget.dart';
import 'quiz_server.dart';
import 'quiz_tts_mixin.dart';
import 'risk_meter_widget.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with QuizTtsMixin {
  final QuizServer _server = QuizServer();
  final PageController _pageController = PageController();

  bool _isLoading = true;
  bool _isLoadingPage = false;
  bool _isReading = false; // controla o ícone do FAB (lendo / parado)
  int _currentPage = 1;
  int _lastPage = 1;

  final Map<int, List<Question>> _pages = {};

  // ── helpers ────────────────────────────────────────────────────
  int get _totalScore => _pages.values
      .expand((q) => q)
      .fold(0, (sum, q) => sum + q.totalScore);

  int get _totalQuestionsLoaded =>
      _pages.values.fold(0, (sum, qs) => sum + qs.length);

  int _getQuestionOffset(int page) {
    int offset = 0;
    for (int i = 1; i < page; i++) {
      offset += _pages[i]?.length ?? 0;
    }
    return offset;
  }

  // ── lifecycle ──────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    initTts(); // inicializa o motor TTS
    _loadPage(1).then((_) {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    disposeTts(); // libera o motor TTS
    super.dispose();
  }

  // ── lógica de carregamento ─────────────────────────────────────
  Future<void> _loadPage(int pageIndex) async {
    if (_pages.containsKey(pageIndex)) return;

    setState(() => _isLoadingPage = true);
    try {
      final result = await _server.fetchQuestions(pageIndex);
      if (!mounted) return;
      setState(() {
        _lastPage = result.lastPage;
        _pages[pageIndex] = result.questions;
      });
    } finally {
      if (mounted) setState(() => _isLoadingPage = false);
    }
  }

  // ── navegação ──────────────────────────────────────────────────
  Future<void> _nextPage() async {
    if (_currentPage < _lastPage) {
      final int nextPageNum = _currentPage + 1;

      if (!_pages.containsKey(nextPageNum)) {
        await _loadPage(nextPageNum);
      }

      if (mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        // Lê a próxima página automaticamente se o auxílio estava ativo
        if (_isReading) {
          _readCurrentPage(page: nextPageNum);
        }
      }
    } else {
      _goToResult();
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToResult() {
    Navigator.pushNamed(context, AppRoutes.result, arguments: _totalScore);
  }

  // ── TTS ────────────────────────────────────────────────────────
  /// Inicia ou para a leitura ao pressionar o FAB.
  Future<void> _toggleReading() async {
    if (_isReading) {
      await stopReading();
      if (mounted) setState(() => _isReading = false);
    } else {
      setState(() => _isReading = true);
      await _readCurrentPage(page: _currentPage);
      // Quando a fala termina naturalmente, volta ao estado parado
      if (mounted) setState(() => _isReading = false);
    }
  }

  /// Dispara a leitura da página [page].
  Future<void> _readCurrentPage({required int page}) async {
    final questions = _pages[page] ?? [];
    await readPage(
      questions: questions,
      questionOffset: _getQuestionOffset(page),
      totalQuestions: _totalQuestionsLoaded,
      pageNumber: page,
      lastPage: _lastPage,
      currentScore: _totalScore,
    );
  }

  // ── build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoading();

    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: const AppHeader(),
      floatingActionButton: _buildFab(),
      body: Column(
        children: [
          _buildStepDots(),

          // 1. Área Paginada das Perguntas
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                if (mounted) setState(() => _currentPage = index + 1);
              },
              itemCount: _lastPage,
              itemBuilder: (context, index) {
                final pageNum = index + 1;

                if (_isLoadingPage && !_pages.containsKey(pageNum)) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final questions = _pages[pageNum] ?? [];
                final offset = _getQuestionOffset(pageNum);

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 660),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(questions.length, (qIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: QuestionWidget(
                              questionNumber: offset + qIndex + 1,
                              totalQuestions: _totalQuestionsLoaded,
                              question: questions[qIndex],
                              onChanged: () {
                                if (mounted) setState(() {});
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Índice de Risco
          _buildIndependentRiskMeterCard(),

          // 3. Navegação
          _buildFixedNavigationArea(),
        ],
      ),
    );
  }

  // ── widgets auxiliares ─────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: _toggleReading,
      backgroundColor: AppColors.primary,
      tooltip: 'Auxílio de Leitura',
      icon: Text(
        _isReading ? '🔇' : '🗣️',
        style: const TextStyle(fontSize: 22),
      ),
      label: Text(
        _isReading ? 'Parar leitura' : 'Auxílio de Leitura',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildIndependentRiskMeterCard() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: RiskMeterWidget(score: _totalScore),
        ),
      ),
    );
  }

  Widget _buildFixedNavigationArea() {
    final bool isLastPage = _currentPage == _lastPage;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 660),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentPage > 1 ? _prevPage : null,
                  style: TextButton.styleFrom(
                    foregroundColor: _currentPage > 1
                        ? AppColors.primary
                        : Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(80, 44),
                  ),
                  child: const Text('← Anterior',
                      style: TextStyle(fontSize: 16)),
                ),
                Text(
                  'Página $_currentPage de $_lastPage',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoadingPage ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(120, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoadingPage
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    isLastPage ? 'Ver Resultado →' : 'Próxima →',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepDots() {
    return Container(
      color: const Color(0xFFF8BBD0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_lastPage, (i) {
          final bool active = (i + 1) == _currentPage;
          final bool done = (i + 1) < _currentPage;
          return Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? AppColors.primary
                  : done
                  ? const Color(0xFFE91E8C)
                  : const Color(0xFFF48FB1),
              border: active
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}