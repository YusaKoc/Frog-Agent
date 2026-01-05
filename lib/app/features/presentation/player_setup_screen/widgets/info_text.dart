import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Listede ilk sıradaki kurbağanın kelimesi önce gösterilir.",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
