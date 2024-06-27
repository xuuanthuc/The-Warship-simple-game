import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 30.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton.icon(
            onPressed: () {
              _confirmExit(context);
            },
            icon: AppImages.arrowBack,
          ),
        ],
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
          height: 150.h,
          child: Center(
            child: Text(
              "Do you want to exit the game?",
              style: TextStyle(
                fontFamily: "Mitr",
                fontWeight: FontWeight.w500,
                fontSize: 22.sp,
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
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              background: AppColors.gray,
              underground: AppColors.grayDark,
            ),
            SizedBox(width: 30.w),
            PrimaryButton.primary(
              onPressed: () {
                context.read<GamePlayCubit>().exitGame();
              },
              text: "OK",
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            )
          ],
        )
      ],
      title: "CONFIRM EXIT",
    );
  }
}
