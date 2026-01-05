// --- Arama TextField ---
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_state.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => SearchTextFieldState();
}

class SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<GroupCubit>().state.searchQuery,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        if (_controller.text != state.searchQuery) {
          _controller.text = state.searchQuery;
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: (value) =>
                context.read<GroupCubit>().setSearchQuery(value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Grup ara',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
