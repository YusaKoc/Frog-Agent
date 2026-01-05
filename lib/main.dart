import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/common/get_it/get_it.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';

import 'package:frog_agent/app/features/presentation/start_page/view/choice_page.dart';
import 'package:frog_agent/firebase_options.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(PlayerGroupAdapter());
  await Hive.openBox<PlayerGroup>('player_groups_box');
  await Hive.openBox<String>('prefs_box');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerCubit>(create: (_) => sl<PlayerCubit>()),
        BlocProvider<GroupCubit>(create: (_) => sl<GroupCubit>()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChoicePage(),
        title: "Frog Agent",
      ),
    );
  }
}
