import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/game_clients/widgets/join_room_dialog.dart';
import 'package:template/src/screens/widgets/primary_button.dart';
import 'package:template/src/screens/widgets/secondary_button.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../bloc/connectivity/connectivity_bloc.dart';
import '../../models/player.dart';
import '../../utilities/toast.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _enterRoomCodeDialog(BuildContext context) {
    showDialog<String?>(
        context: context,
        builder: (context) {
          return const JoinRoomDialog();
        }).then((code) {
      if (code != null) {
        final connectionResult = context.read<ConnectivityBloc>().state.result;
        if (connectionResult == ConnectivityResult.wifi ||
            connectionResult == ConnectivityResult.mobile) {
          final player = GuestPlayer(
            id: const Uuid().v4(),
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
            connectivityResult: connectionResult,
            ready: false,
          );
          context.read<GameClientCubit>().joinRoom(
                player: player,
                code: code,
              );
        }
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
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryButton(
              onPressed: () => _launchUrl(
                "https://github.com/xuuanthuc/battleship",
              ),
              text: "GITHUB",
              icon: AppImages.github,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryButton(
              onPressed: () => _launchUrl(
                "https://stackoverflow.com/users/15110149/xuuan-thuc",
              ),
              text: "STACK",
              icon: AppImages.stackOverflow,
            ),
          ),
          const Spacer(),
          PrimaryButton.primary(
            onPressed: () {
              final connectionResult =
                  context.read<ConnectivityBloc>().state.result;
              if (connectionResult == ConnectivityResult.wifi ||
                  connectionResult == ConnectivityResult.mobile) {
                final player = OwnerPlayer(
                  id: const Uuid().v4(),
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                  connectivityResult: connectionResult,
                  ready: false,
                );
                context.read<GameClientCubit>().createNewRoom(
                      player: player,
                      status: GameStatus.init,
                    );
              }
            },
            text: "CREATE ROOM",
            fontSize: 30,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 32),
          ),
          const SizedBox(height: 30),
          PrimaryButton.secondary(
            onPressed: () => _enterRoomCodeDialog(context),
            text: "JOIN ROOM",
            fontSize: 24,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
          ),
        ],
      ),
    );
  }
}
