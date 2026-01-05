import 'package:bloc/bloc.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/data/local/repository/player_group_repo.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository repo;
  GroupCubit(this.repo) : super(const GroupState());

  void load() {
    emit(state.copyWith(isLoading: true));
    final list = repo.getAll();
    emit(state.copyWith(isLoading: false, groups: list, error: null));
  }

  Future<void> create(String name, List<String> players) async {
    if (name.trim().isEmpty) {
      emit(state.copyWith(error: 'Grup adı boş olamaz.'));
      return;
    }
    // aynı isim varsa _1, _2 postfix düşünebilirsin; şimdilik direkt yaratıyoruz.
    await repo.create(name, players);
    load();
  }

  Future<void> update(PlayerGroup group) async {
    await repo.update(group);
    load();
  }

  Future<void> delete(String id) async {
    await repo.delete(id);
    load();
  }

  Future<void> setLastUsed(String id) async {
    await repo.saveLastGroupId(id);
  }

  Future<void> clearLastUsed() async => repo.clearLastGroupId();

  String? getLastUsed() => repo.getLastGroupId();

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
