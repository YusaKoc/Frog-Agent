import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/player_setup_button_style.dart';

class AddPlayerSection extends StatelessWidget {
  const AddPlayerSection({
    super.key,
    required this.canAdd,
    required this.onAdd,
    required this.onClear,
  });

  final bool canAdd;
  final VoidCallback onAdd;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: PlayerSetupButtonStyle.buttonStyle(),
            onPressed: canAdd ? onAdd : null,
            child: const Text('Kullanıcı Ekle'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Listeyi temizle',
          onPressed: onClear,
          icon: const Icon(Icons.clear),
        ),
      ],
    );
  }
}
