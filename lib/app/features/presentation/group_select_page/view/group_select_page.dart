import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/common/get_it/get_it.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/helpers/group_select_helpers.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/widgets/groups_list_view.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/widgets/last_group_build_card.dart';
import 'package:frog_agent/app/features/presentation/group_select_page/widgets/search_text_field.dart';

class GroupSelectPage extends StatelessWidget {
  const GroupSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupCubit>(
      create: (_) => sl<GroupCubit>()..load(),
      child: const _GroupSelectView(),
    );
  }
}

class _GroupSelectView extends StatelessWidget {
  const _GroupSelectView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFc1fba4), Color(0xFF7ed6a3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar benzeri üst şerit
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: Row(
                  children: [
                    Text(
                      'Gruplar',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2e7d5b),
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Mevcut oyuncuları grup olarak kaydet',
                      icon: const Icon(Icons.save_alt),
                      onPressed: () => saveCurrentAsGroup(context),
                    ),
                  ],
                ),
              ),

              // Özet kart + son kullanılan rozet
              const LastGroupBuildCard(),

              // Arama kutusu
              const SearchTextField(),

              // Liste alanı
              const GroupListView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7ed6a3),
        foregroundColor: Colors.white,
        onPressed: () => createGroup(context),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Grup'),
      ),
    );
  }
}
