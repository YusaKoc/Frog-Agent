import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_state.dart';

class LastGroupBuildCard extends StatelessWidget {
  const LastGroupBuildCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, gState) {
          final lastId = context.read<GroupCubit>().getLastUsed();
          final lastGroup = (lastId == null)
              ? null
              : gState.groups
                  .where((e) => e.id == lastId)
                  .cast<PlayerGroup?>()
                  .firstOrNull;
          return Card(
            color: const Color(0xFFfff5a5),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Image.asset("assets/images/agent_frog.png", width: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kayıtlı Grup Sayısı',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: const Color(0xFF4aa96c),
                                  fontWeight: FontWeight.w700,
                                )),
                        const SizedBox(height: 4),
                        Text(
                          '${gState.groups.length}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2e7d5b),
                              ),
                        ),
                        if (lastGroup != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.history,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 6),
                                Text(
                                  'Son kullanılan: ${lastGroup.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// küçük extension: firstOrNull
extension _IterableX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
