import 'package:flutter/material.dart';
import '../common/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Apoio institucional',
            style: TextStyle(
              color: Color(0xFFFCE4EC),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogoSlot('assets/images/apoiador1.png', 'Secretaria\nda Mulher'),
              const SizedBox(width: 16),
              _buildLogoSlot('assets/images/apoiador2.png', 'Unicatólica'),
              const SizedBox(width: 16),
              _buildLogoSlot('assets/images/apoiador3.png', 'CNJ / CNMP'),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            '© 2026 Desperta Mulher — Secretaria da Mulher do Tocantins',
            style: TextStyle(color: Color(0xFFF8BBD0), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Imagens devem estar em assets/images/apoiador1.png, apoiador2.png, apoiador3.png
  Widget _buildLogoSlot(String assetPath, String fallbackText) {
    return Container(
      width: 100,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (_, __, ___) => Text(
          fallbackText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
