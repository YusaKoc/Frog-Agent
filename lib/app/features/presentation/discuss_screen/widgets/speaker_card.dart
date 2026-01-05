import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';

class SpeakerCard extends StatelessWidget {
  const SpeakerCard({
    super.key,
    required this.name,
    required this.index,
    required this.isFirst,
    this.isEliminated = false,
  });

  final String name;
  final int index;
  final bool isFirst;
  final bool isEliminated;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEliminated ? 0.5 : 1.0,
      child: Card(
        color: isEliminated ? Colors.grey[200] : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          leading: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isEliminated
                    ? Colors.grey[400]
                    : const Color(0xFFc1fba4),
                child: Text(
                  "$index",
                  style: TextStyle(
                    color: isEliminated
                        ? Colors.grey[600]
                        : const Color(0xFF2e7d5b),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isEliminated)
                Positioned(
                  right: -8,
                  bottom: -8,
                  child: Image.asset(
                    AssetPaths.citizenFrog,
                    width: 26,
                  ),
                ),
            ],
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              decoration: isEliminated
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: isEliminated ? Colors.grey[600] : Colors.black,
            ),
          ),
          subtitle: isEliminated
              ? const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, size: 16, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        "Elenmiş",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : isFirst
                  ? const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.record_voice_over,
                              size: 16, color: Colors.black54),
                          SizedBox(width: 6),
                          Text("Sıradaki konuşmacı"),
                        ],
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}

