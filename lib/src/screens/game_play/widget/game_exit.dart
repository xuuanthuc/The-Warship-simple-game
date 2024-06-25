import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/routes/navigation_service.dart';
import 'package:template/src/screens/widgets/primary_button.dart';
import 'package:template/src/screens/widgets/primary_dialog.dart';
import 'package:template/src/style/app_colors.dart';

import '../../../style/app_images.dart';
import '../../widgets/secondary_button.dart';

class GameExitButton extends StatelessWidget {
  const GameExitButton({super.key});

  void _confirmExit(BuildContext context) {
    showDialog<String?>(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<GamePlayCubit>(),
            child: const ConfirmExitGameDialog(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      height: 80,
      child: SecondaryButton.icon(
        onPressed: () {
          _confirmExit(context);
        },
        icon: AppImages.arrowBack,
      ),
    );
  }
}

class ConfirmExitGameDialog extends StatelessWidget {
  const ConfirmExitGameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryDialog(
      children: [
        Container(
          height: 120,
          child: Center(
            child: Text(
              "Do you want to exit the game?",
              style: TextStyle(
                fontFamily: "Mitr",
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton.primary(
              onPressed: () {
                navService.pop();
              },
              text: "Cancel",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              background: AppColors.gray,
              underground: AppColors.grayDark,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            const SizedBox(width: 30),
            PrimaryButton.primary(
              onPressed: () {
                context.read<GamePlayCubit>().exitGame();
              },
              text: "OK",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            )
          ],
        )
      ],
      title: "CONFIRM EXIT",
    );
  }
}
