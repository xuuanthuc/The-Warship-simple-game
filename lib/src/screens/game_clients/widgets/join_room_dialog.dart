import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/src/screens/widgets/primary_button.dart';
import 'package:template/src/screens/widgets/primary_dialog.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:uuid/uuid.dart';
import '../../../models/player.dart';
import '../../../routes/navigation_service.dart';
import '../bloc/game_client_cubit.dart';

class JoinRoomDialog extends StatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameClientCubit, GameClientState>(
      listenWhen: (prev, curr) => curr.action == ClientAction.join,
      listener: (context, state) {
        if (state.status == ClientStatus.success) {
          navService.pop();
        }
      },
      child: PrimaryDialog(
        title: "Join with Room ID",
        children: [
          BlocBuilder<GameClientCubit, GameClientState>(
            buildWhen: (prev, curr) => curr.action == ClientAction.join,
            builder: (context, state) {
              final message = state.message ?? "";
              return Text(
                message.isEmpty ? "Enter Room ID to join the room" : message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Mitr",
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: message.isEmpty ? Colors.white : Colors.red.shade700,
                ),
              );
            },
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 20.h,
            ).copyWith(bottom: 10.h),
            child: TextField(
              controller: _editingController,
              textAlign: TextAlign.center,
              autofocus: true,
              cursorWidth: 5.w,
              maxLength: 6,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              style:  TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              cursorColor: AppColors.grayDark,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.grayDark, width: 4),
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
                final player = GuestPlayer(
                    id: const Uuid().v4(),
                    createdAt: Timestamp.now(),
                    updatedAt: Timestamp.now(),
                    connectivityResult: ConnectivityResult.wifi,
                    ready: false,
                    skin: context.read<GameClientCubit>().state.skin);
                context.read<GameClientCubit>().joinRoom(
                      player: player,
                      code: code,
                    );
              }
            },
            text: "Join",
            fontSize: 20.sp,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
          ),
          SizedBox(height: 30.h),
        ],
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
