import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/risk_level.dart';

export '../../common/risk_level.dart' show RiskLevel, riskLevelFor;

class RiskMeterWidget extends StatelessWidget {
  final int score;
  final int maxScore;

  const RiskMeterWidget({
    super.key,
    required this.score,
    this.maxScore = 200,
  });

  @override
  Widget build(BuildContext context) {
    final level = riskLevelFor(score, maxScore: maxScore);
    final theme = RiskTheme.of(level);
    final pct   = (score / maxScore).clamp(0.0, 1.0);

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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '📊  Avaliação de Risco em Tempo Real',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 500),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 28,
                backgroundColor: AppColors.primaryLighter,
                valueColor: AlwaysStoppedAnimation(theme.fillColor),
              ),
            ),
          ),
          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('● Baixo',  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.riskGreenText)),
              Text('● Médio',  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.riskYellowText)),
              Text('● Alto',   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.riskRedText)),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: theme.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              theme.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: theme.textColor,
              ),
            ),
          ),
          const SizedBox(height: 10),

          Center(
            child: Text(
              'Pontuação atual: $score pontos',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
