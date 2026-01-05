import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/widgets/discuss_bottom_action_bar.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/widgets/discuss_info_card.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/widgets/speaking_order_list.dart';

class DiscussScreen extends StatelessWidget {
  const DiscussScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // build içinde doğrudan state değiştirmemek için post-frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PlayerCubit>();
      cubit.generateSpeakingOrderOnce();
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFc1fba4), Color(0xFF7ed6a3)],
          ),
        ),
        child: const SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 8),
              DiscussInfoCard(),
              SizedBox(height: 8),
              SpeakingOrderList(),
              DiscussBottomActionBar(),
            ],
          ),
        ),
      ),
    );
  }
}
