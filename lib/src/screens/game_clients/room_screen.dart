import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/widgets/bounce_button.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/utilities/toast.dart';

import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-0.02, 0),
    end: const Offset(0.02, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameClientCubit, GameClientState>(
      builder: (context, state) {
        final currentPlayer = state.player;
        final hostPlayer = state.room?.ownerPlayer;
        final iamHost = currentPlayer != null &&
            hostPlayer != null &&
            currentPlayer.id == hostPlayer.id;

        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SecondaryButton.icon(
                      onPressed: () {
                        if (iamHost) {
                          context.read<GameClientCubit>().deleteRoom();
                        } else {
                          context.read<GameClientCubit>().outRoom();
                        }
                      },
                      icon: AppImages.arrowBack,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SlideTransition(
                                  position: _offsetAnimation,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                              0.6,
                                    ),
                                    margin: const EdgeInsets.all(20),
                                    child: Image.asset(
                                        state.skin?.preview() ?? ""),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 100,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 30),
                            itemBuilder: (context, index) {
                              return BounceButton(
                                onPressed: () {
                                  context
                                      .read<GameClientCubit>()
                                      .setSkin(BattleshipSkin.values[index]);
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        width: 5,
                                        color: Colors.white,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white30,
                                            offset: Offset(0, 4),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 10,
                                        color: state.skin ==
                                                BattleshipSkin.values[index]
                                            ? AppColors.primaryDark
                                            : AppColors.primary,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: BattleshipSkin.values[index]
                                          .background(),
                                    ),
                                    child: Image.asset(
                                      BattleshipSkin.values[index].preview(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: BattleshipSkin.values.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Column(
                //       children: [
                //         Container(
                //           width: iamHost ? 100 : 80,
                //           height: iamHost ? 100 : 80,
                //           color: Colors.cyan,
                //           child: Text(
                //             state.room?.ownerPlayer?.id ?? 'Player 1',
                //             style: TextStyle(
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //         Text(iamHost ? "You" : "Opponent")
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Container(
                //           width: iamHost ? 80 : 100,
                //           height: iamHost ? 80 : 100,
                //           color: Colors.red,
                //           child: Text(
                //             state.room?.guestPlayer?.id ?? 'Player 2',
                //             style: TextStyle(
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //         Text(iamHost ? "Opponent" : "You")
                //       ],
                //     ),
                //   ],
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BounceButton(
                      onPressed: () async {
                        if ((state.room?.code ?? "").isEmpty) return;
                        await Clipboard.setData(
                            ClipboardData(text: state.room!.code!));
                        if (context.mounted) {
                          appToast(context, message: "Copied to clipboard!");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 3,
                            color: Colors.black,
                          ),
                          color: AppColors.grayDark,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Text(
                                    state.room?.code ?? '',
                                    style: TextStyle(
                                      fontFamily: "Mitr",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      letterSpacing: 2,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = Colors.black,
                                    ),
                                  ),
                                  Text(
                                    state.room?.code ?? '',
                                    style: TextStyle(
                                      fontFamily: "Mitr",
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                height: 30,
                                child: Image.asset(
                                  AppImages.copy,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!iamHost) Spacer(),
                    const SizedBox(width: 30),
                    PrimaryButton.primary(
                      onPressed: () async {
                        final room = state.room;
                        final player = state.player;
                        if (room == null || player == null) return;
                        context
                            .read<GamePlayCubit>()
                            .getRoomDataToPrepareBattleGame(room, player);
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (iamHost) {
                          if (room.guestPlayer?.ready == true) {
                            if (context.mounted) {
                              context.read<GameClientCubit>().start();
                            }
                          }
                        } else {
                          context.read<GameClientCubit>().guestReady();
                        }
                      },
                      text: iamHost
                          ? "START"
                          : state.room?.guestPlayer?.ready == true
                              ? "CANCEL"
                              : "READY",
                      fontSize: 30,
                      background: state.room?.guestPlayer?.ready == true
                          ? iamHost
                              ? AppColors.primary
                              : AppColors.gray
                          : iamHost
                              ? AppColors.gray
                              : AppColors.primary,
                      underground: state.room?.guestPlayer?.ready == true
                          ? iamHost
                              ? AppColors.primaryDark
                              : AppColors.grayDark
                          : iamHost
                              ? AppColors.grayDark
                              : AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 50),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 3,
                    color: Colors.black,
                  ),
                  color: AppColors.grayDark,
                ),
                child: Container(
                  width: 160,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: iamHost ? Colors.white24 : Colors.transparent,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: BounceButton(
                          onPressed: () async {},
                          child: Row(
                            children: [
                              Text(
                                iamHost ? "You" : "Host",
                                style: TextStyle(
                                  fontFamily: "Mitr",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                height: 25,
                                child: Image.asset(
                                  AppImages.connect,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: iamHost ? Colors.transparent : Colors.white24,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: BounceButton(
                          onPressed: () async {},
                          child: Row(
                            children: [
                              Text(
                                state.room?.guestPlayer == null
                                    ? "..."
                                    : iamHost
                                        ? "Guest"
                                        : "You",
                                style: TextStyle(
                                  fontFamily: "Mitr",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Visibility(
                                visible: state.room?.guestPlayer != null,
                                child: SizedBox(
                                  height: 25,
                                  child: Image.asset(
                                    AppImages.connect,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
