import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/screens/game_play/game_play.dart';
import 'package:template/src/screens/widgets/primary_button.dart';
import 'package:template/src/style/app_colors.dart';

import '../../../components/empty_square_component.dart';
import '../../../components/occupied_component.dart';

class GameReadyButton extends StatefulWidget {
  final BattleGameFlame game;

  const GameReadyButton({
    super.key,
    required this.game,
  });

  @override
  State<GameReadyButton> createState() => _GameReadyButtonState();
}

class _GameReadyButtonState extends State<GameReadyButton> {
  
  Color _backgroundColor = AppColors.primary;
  Color _undergroundColor = AppColors.primaryDark;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePlayCubit, GamePlayState>(
      buildWhen: (previousState, newState) =>
          newState.status == ReadyStatus.preparing ||
          newState.status == ReadyStatus.prepared ||
          previousState.status != newState.status,
      builder: (context, state) {
        if (state.status == ReadyStatus.prepared) {
          return Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(30),
              child: PrimaryButton.primary(
                background: _backgroundColor,
                underground: _undergroundColor,
                onPressed: () {
                  setState(() {
                    _backgroundColor = AppColors.gray;
                    _undergroundColor = AppColors.gray;
                  });
                  context.read<GamePlayCubit>().readyForBattle(
                        occupiedItems: widget.game.world.children
                            .query<ReadyBattleWorld>()
                            .first
                            .children
                            .query<OccupiedComponent>(),
                        blocks: widget.game.world.children
                            .query<ReadyBattleWorld>()
                            .first
                            .children
                            .query<EmptySquareComponent>(),
                      );
                },
                text: "Ready",
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
