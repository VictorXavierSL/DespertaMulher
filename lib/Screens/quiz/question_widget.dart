import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../models/answer.dart';
import '../../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final int questionNumber;
  final int totalQuestions;
  final Question question;
  final VoidCallback onChanged;

  const QuestionWidget({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
    required this.onChanged,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  void _toggle(Answer answer) {
    setState(() => widget.question.toggleAnswer(answer));
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionNumber(),
          const SizedBox(height: 10),
          _buildTitle(),
          if (widget.question.multipleChoice) ...[
            const SizedBox(height: 12),
            _buildMultiBadge(),
          ],
          const SizedBox(height: 16),
          ...widget.question.answers.map(_buildOption),
        ],
      ),
    );
  }

  Widget _buildQuestionNumber() {
    return Text(
      'PERGUNTA ${widget.questionNumber} DE ${widget.totalQuestions}',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE91E8C),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.question.title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.45,
      ),
    );
  }

  Widget _buildMultiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Pode marcar mais de uma opção',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildOption(Answer answer) {
    final bool selected = widget.question.isSelected(answer);

    return GestureDetector(
      onTap: () => _toggle(answer),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLighter : AppColors.primaryPale,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stepBarBg,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            _buildSelectionIcon(selected),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                answer.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textDark,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIcon(bool selected) {
    if (widget.question.multipleChoice) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.primaryLight,
            width: 2.5,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.primaryLight,
          width: 2.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.circle, size: 12, color: Colors.white)
          : null,
    );
  }
}
