import 'package:flutter/material.dart';

class PlayerSetupButtonStyle {
  static ButtonStyle buttonStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7ed6a3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        elevation: 1.5,
      );
}

