import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/routes/navigation_service.dart';
import 'package:template/src/routes/route_keys.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/game_clients/lobby_screen.dart';
import 'package:template/src/screens/game_clients/room_screen.dart';
import 'package:template/src/utilities/game_data.dart';

import '../../style/app_images.dart';
import '../widgets/secondary_button.dart';

class GameClientScreen extends StatefulWidget {
  const GameClientScreen({super.key});

  @override
  State<GameClientScreen> createState() => _GameClientScreenState();
}

class _GameClientScreenState extends State<GameClientScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<GameClientCubit, GameClientState>(
        listener: (context, state) {
          if (state.room?.gameStatus == GameStatus.preparing) {
            context.read<GameClientCubit>().close();
            navService.pushReplacementNamed(RouteKey.gamePlay);
          }
        },
        child: BlocBuilder<GameClientCubit, GameClientState>(
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
              decoration: BoxDecoration(
                gradient: state.skin?.background(),
              ),
              child: Stack(
                children: [
                  ScaleTransition(
                    scale:
                        Tween<double>(begin: 1, end: 1.05).animate(_controller),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: Image.asset(
                        AppImages.lobby,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30).copyWith(bottom: 50),
                    child: state.room != null
                        ? const RoomScreen()
                        : const LobbyScreen(),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(30).copyWith(bottom: 50),
                      child: SizedBox(
                        height: 80,
                        child: SecondaryButton.icon(
                          onPressed: () {},
                          icon: AppImages.menu,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
