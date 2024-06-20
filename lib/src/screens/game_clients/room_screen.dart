import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  BattleshipSkin _occupiedPreview = BattleshipSkin.A;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameClientCubit, GameClientState>(
      builder: (context, state) {
        final currentPlayer = state.player;
        final hostPlayer = state.room?.ownerPlayer;
        final iamHost = currentPlayer != null &&
            hostPlayer != null &&
            currentPlayer.id == hostPlayer.id;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (iamHost) {
                      context.read<GameClientCubit>().deleteRoom();
                    } else {
                      context.read<GameClientCubit>().outRoom();
                    }
                  },
                  child: Text("Exit room"),
                ),
                Text("Waiting the opponent..."),
              ],
            ),
            Text(
              state.room?.code ?? '',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.cyan,
                      child: Text(
                        state.room?.ownerPlayer?.id ?? 'Player 1',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(iamHost ? "You" : "Opponent")
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: Text(
                        state.room?.guestPlayer?.id ?? 'Player 2',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(iamHost ? "Opponent" : "You")
                  ],
                ),
              ],
            ),
            Text("Select your skin"),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 300,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 300,
                    child: Image.asset(
                      "assets/images/${AppImages.background}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Image.asset(
                        _occupiedPreview == BattleshipSkin.A
                            ? "assets/images/${AppImages.previewA}"
                            : "assets/images/${AppImages.previewB}",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _occupiedPreview = BattleshipSkin.A;
                      GameData.instance.setOccupiedSkin(_occupiedPreview);
                    });
                  },
                  child: Text("Skin A"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _occupiedPreview = BattleshipSkin.B;
                      GameData.instance.setOccupiedSkin(_occupiedPreview);
                    });
                  },
                  child: Text("Skin B"),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  state.room?.guestPlayer?.ready == true
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              onPressed: () async {
                final room = state.room;
                final player = state.player;
                if (room == null || player == null) return;
                context
                    .read<GamePlayCubit>()
                    .getRoomDataToPrepareBattleGame(room, player);
                await Future.delayed(Duration(milliseconds: 300));
                if (iamHost) {
                  if (room.guestPlayer?.ready == true) {
                    print("start game");
                    context.read<GameClientCubit>().start();
                  } else {
                    print("opponent not Ready game");
                  }
                } else {
                  context.read<GameClientCubit>().guestReady();
                }
              },
              child: Text(
                iamHost
                    ? "Start"
                    : state.room?.guestPlayer?.ready == true
                        ? "Cancel ready"
                        : "Ready",
              ),
            ),
          ],
        );
      },
    );
  }
}
