import 'package:flutter/material.dart';

class VotingBottomInfo extends StatelessWidget {
  const VotingBottomInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        "Karar vermeden önce kısa bir tartışma iyi gelebilir 🐸",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

