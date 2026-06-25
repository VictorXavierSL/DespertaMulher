import 'package:flutter/material.dart';
import '../common/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      centerTitle: true,
      elevation: 3,
      title: Column(
        children: const [
          Text(
            '🌸 Desperta Mulher',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'Formulário de Avaliação de Risco — FONAR',
            style: TextStyle(
              color: Color(0xFFF8BBD0),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
