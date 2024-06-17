import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/routes/navigation_service.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/utilities/logger.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/connectivity/connectivity_bloc.dart';
import '../../models/player.dart';
import '../../utilities/toast.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _controller = TextEditingController();

  void _enterRoomCodeDialog() {
    showDialog<String?>(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                ),
                ElevatedButton(
                  onPressed: () {
                    navService.pop(result: _controller.text);
                  },
                  child: Text("Join room"),
                )
              ],
            ),
          );
        }).then((code) {
      print(code);
      if (code != null) {
        if (context.read<ConnectivityBloc>().state.result ==
                ConnectivityResult.wifi ||
            context.read<ConnectivityBloc>().state.result ==
                ConnectivityResult.mobile) {
          final player = OpponentPlayer(
            id: Uuid().v4(),
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
            connectivityResult: context.read<ConnectivityBloc>().state.result,
          );
          context.read<GameClientCubit>().joinRoom(
                player: player,
                code: code,
              );
        }
      } else {
        print("no Internet");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state.result == ConnectivityResult.none) {
          appToast(context, message: "No connection");
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (context.read<ConnectivityBloc>().state.result ==
                      ConnectivityResult.wifi ||
                  context.read<ConnectivityBloc>().state.result ==
                      ConnectivityResult.mobile) {
                final player = OwnerPlayer(
                  id: Uuid().v4(),
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                  connectivityResult:
                      context.read<ConnectivityBloc>().state.result,
                );
                context.read<GameClientCubit>().createNewRoom(
                      player: player,
                      status: context.read<GamePlayCubit>().state.status,
                    );
              }
            },
            child: Text("Create room"),
          ),
          ElevatedButton(
            onPressed: () {
              _enterRoomCodeDialog();
            },
            child: Text("Join room"),
          )
        ],
      ),
    );
  }
}
