import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/game_play/game_play.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';

import '../../../bloc/game_play/game_play_cubit.dart';

class TurnIntro extends StatefulWidget {
  final BattleGameFlame game;
  final bool isOpponent;

  const TurnIntro({
    super.key,
    required this.game,
    required this.isOpponent,
  });

  @override
  State<TurnIntro> createState() => _TurnIntroState();
}

class _TurnIntroState extends State<TurnIntro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation;


  @override
  void initState() {
    _offsetAnimation = Tween<Offset>(
      begin: widget.isOpponent ? const Offset(0.2, 0) : const Offset(-0.2, 0),
      end: widget.isOpponent ? const Offset(0, 0) : const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.forward();
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePlayCubit, GamePlayState>(
      buildWhen: (_, cur) => cur.action == GameAction.nextTurn,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      gradient: state.room.nextPlayer?.skin?.background()
                  ),
                ),
              ),
              Center(
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: SizedBox(
                    height: 200,
                    child: Image.asset(
                      "assets/images/${widget.isOpponent
                          ? AppImages.opponentTurn
                          : AppImages.yourTurn}",
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
