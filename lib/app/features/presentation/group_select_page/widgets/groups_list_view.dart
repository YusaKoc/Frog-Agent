import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_state.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/helpers/group_select_helpers.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/widgets/empty_state.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/widgets/group_card.dart';

class GroupListView extends StatelessWidget {
  const GroupListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final query = state.searchQuery.trim().toLowerCase();
          final filtered = query.isEmpty
              ? state.groups
              : state.groups
                  .where((g) => g.name.toLowerCase().contains(query))
                  .toList();

          if (filtered.isEmpty) {
            return EmptyState(onCreateTap: () => createGroup(context));
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<GroupCubit>().load(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final g = filtered[i];
                return Dismissible(
                  key: ValueKey(g.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => confirmDelete(context, g),
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GroupCard(
                    group: g,
                    onQuickStart: () => quickStart(context, g),
                    onEdit: () => editGroup(context, g),
                    onDelete: () async {
                      final ok = await confirmDelete(context, g);
                      if (ok == true && context.mounted) {
                        context.read<GroupCubit>().delete(g.id);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
