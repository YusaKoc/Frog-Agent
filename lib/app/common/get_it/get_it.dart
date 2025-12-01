import 'package:firebase_auth/firebase_auth.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/data/local/repository/player_group_repo.dart';

import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<PlayerCubit>(() => PlayerCubit());
  sl.registerLazySingleton<GroupRepository>(() => GroupRepository(
      Hive.box<PlayerGroup>('player_groups_box'),
      Hive.box<String>('prefs_box')));
  sl.registerFactory<GroupCubit>(() => GroupCubit(sl<GroupRepository>()));
  // Firebase singletons
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
}
