import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/widgets/primary_button.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:uuid/uuid.dart';
import '../../../bloc/connectivity/connectivity_bloc.dart';
import '../../../models/player.dart';
import '../../../routes/navigation_service.dart';
import '../bloc/game_client_cubit.dart';

class JoinRoomDialog extends StatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  final TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameClientCubit, GameClientState>(
      listenWhen: (prev, curr) => curr.action == ClientAction.join,
      listener: (context, state) {
        if (state.status == ClientStatus.success) {
          navService.pop();
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.3,
            constraints: const BoxConstraints(minWidth: 500),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 1.05)
                          .animate(_controller),
                      child: Image.asset(
                        AppImages.lobby,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.grayDark,
                        border: Border(
                          bottom: BorderSide(
                            width: 4,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      height: 64,
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                "Join with Room ID",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Mitr",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => navService.pop(),
                                icon: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(AppImages.close),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<GameClientCubit, GameClientState>(
                      buildWhen: (prev, curr) =>
                          curr.action == ClientAction.join,
                      builder: (context, state) {
                        final message = state.message ?? "";
                        return Text(
                          message.isEmpty
                              ? "Enter Room ID to join the room"
                              : message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Mitr",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: message.isEmpty
                                ? Colors.white
                                : Colors.red.shade700,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ).copyWith(bottom: 10),
                      child: TextField(
                        controller: _editingController,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        cursorWidth: 5,
                        maxLength: 6,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        cursorColor: AppColors.grayDark,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: AppColors.grayDark, width: 4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.grayDark,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PrimaryButton.primary(
                      onPressed: () {
                        final code = _editingController.text;
                        if (code.isNotEmpty) {
                          final connectionResult =
                              context.read<ConnectivityBloc>().state.result;
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
                        // navService.pop(result: _editingController.text);
                      },
                      text: "Join",
                      fontSize: 20,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
