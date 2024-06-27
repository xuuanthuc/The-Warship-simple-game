import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../game_play/widget/game_exit.dart';

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
        builder: (_) {
          return BlocProvider.value(
            value: context.read<GameClientCubit>(),
            child: const JoinRoomDialog(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.6
                  ),
                  child: Image.asset(AppImages.logo),
                ),
              ),
            ),
            PrimaryButton.primary(
              onPressed: () {
                final player = OwnerPlayer(
                    id: const Uuid().v4(),
                    createdAt: Timestamp.now(),
                    updatedAt: Timestamp.now(),
                    connectivityResult: ConnectivityResult.wifi,
                    ready: false,
                    skin: context.read<GameClientCubit>().state.skin);
                context.read<GameClientCubit>().createNewRoom(
                      player: player,
                      status: GameStatus.init,
                    );
              },
              text: "CREATE ROOM",
              fontSize: 30.sp,
              padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 32.w),
            ),
            SizedBox(height: 30.h),
            PrimaryButton.secondary(
              onPressed: () => _enterRoomCodeDialog(context),
              text: "JOIN ROOM",
              fontSize: 24.sp,
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 30.w,
              ),
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SizedBox(height: 10.h),
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
            ],
          ),
        )
      ],
    );
  }
}
