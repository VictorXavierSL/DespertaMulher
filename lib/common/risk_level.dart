import 'package:flutter/material.dart';
import 'app_colors.dart';

enum RiskLevel { low, medium, high }

RiskLevel riskLevelFor(int score, {int maxScore = 200}) {
  final pct = (score / maxScore * 100).clamp(0.0, 100.0);
  if (pct < 30) return RiskLevel.low;
  if (pct < 65) return RiskLevel.medium;
  return RiskLevel.high;
}

class RiskTheme {
  final Color fillColor;
  final Color bgColor;
  final Color textColor;
  final String label;
  final String description;

  const RiskTheme({
    required this.fillColor,
    required this.bgColor,
    required this.textColor,
    required this.label,
    required this.description,
  });

  static RiskTheme of(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return const RiskTheme(
          fillColor: AppColors.riskGreenFill,
          bgColor: AppColors.riskGreenBg,
          textColor: AppColors.riskGreenText,
          label: '🟢  Risco Baixo',
          description:
              'Sua pontuação indica um nível de risco baixo no momento. '
              'Mesmo assim, você merece viver com segurança e dignidade. '
              'Se precisar de apoio, procure a rede de proteção disponível.',
        );
      case RiskLevel.medium:
        return const RiskTheme(
          fillColor: AppColors.riskYellowFill,
          bgColor: AppColors.riskYellowBg,
          textColor: AppColors.riskYellowText,
          label: '🟡  Risco Médio — Atenção',
          description:
              'Sua pontuação indica situação de atenção. Recomendamos que '
              'você busque orientação com profissionais da rede de proteção — '
              'uma psicóloga, assistente social ou delegacia da mulher pode ajudá-la.',
        );
      case RiskLevel.high:
        return const RiskTheme(
          fillColor: AppColors.riskRedFill,
          bgColor: AppColors.riskRedBg,
          textColor: AppColors.riskRedText,
          label: '🔴  Risco Alto — Busque Ajuda',
          description:
              'Sua pontuação indica risco elevado. Por favor, busque ajuda com '
              'urgência. Ligue para o 180 (Central de Atendimento à Mulher) ou '
              'procure a delegacia da mulher mais próxima. Você não está sozinha.',
        );
    }
  }
}
