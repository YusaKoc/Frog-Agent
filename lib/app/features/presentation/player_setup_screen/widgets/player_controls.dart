import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/view/group_select_page.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.maxPlayers,
    required this.onMaxPlayersChanged,
  });

  final int maxPlayers;
  final ValueChanged<int> onMaxPlayersChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2e7d5b),
              side: const BorderSide(color: Color(0xFF2e7d5b)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GroupSelectPage(),
                ),
              );
            },
            icon: const Icon(Icons.group),
            label: const Text('Gruplardan Seç'),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: maxPlayers,
              items: List.generate(10, (i) => i + 3)
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text("$e Frogs 🐸"),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onMaxPlayersChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
