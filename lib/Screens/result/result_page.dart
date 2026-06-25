import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/app_routes.dart';
import '../../common/risk_level.dart';
import '../app_footer.dart';
import '../app_header.dart';
import '../quiz/risk_meter_widget.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int score =
        ModalRoute.of(context)!.settings.arguments as int;

    final level = riskLevelFor(score);
    final rt    = RiskTheme.of(level);

    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: const AppHeader(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 660),
                  child: Column(
                    children: [
                      _buildResultCard(context, score, rt),
                      const SizedBox(height: 20),
                      RiskMeterWidget(score: score),
                      const SizedBox(height: 20),
                      _buildBackButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, int score, RiskTheme rt) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Text(
            'Resultado do Formulário',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            decoration: BoxDecoration(
              color: rt.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              rt.label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: rt.textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '$score',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w800,
              color: rt.textColor,
              height: 1,
            ),
          ),
          const Text(
            'pontos acumulados',
            style: TextStyle(fontSize: 17, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),

          Text(
            rt.description,
            style: const TextStyle(
              fontSize: 20,
              height: 1.6,
              color: Color(0xFF555555),
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              '📞  Ligue 180 — Central de Atendimento à Mulher\nGratuito, 24 horas, sigiloso',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.quiz, (_) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                '↩  Refazer o formulário',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text(
          '← Voltar',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
      ),
    );
  }
}
