// lib/app/features/groups/presentation/cubit/group_state.dart
import 'package:equatable/equatable.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';

class GroupState extends Equatable {
  final List<PlayerGroup> groups;
  final bool isLoading;
  final String? error;

  const GroupState({
    this.groups = const [],
    this.isLoading = false,
    this.error,
  });

  GroupState copyWith({
    List<PlayerGroup>? groups,
    bool? isLoading,
    String? error,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [groups, isLoading, error];
}
