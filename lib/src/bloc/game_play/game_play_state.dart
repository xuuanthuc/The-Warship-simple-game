part of 'game_play_cubit.dart';

enum GameAction {
  prepare,
  shuffle,
  ready,
  play,
  checkHit,
  checkSunk,
  shoot,
  continueTurn,
  nextTurn,
  pause,
  end
}

enum ReadyStatus {
  init,
  preparing,
  prepared,
  ready,
  playing
}

@immutable
class GamePlayState extends Equatable {
  final ReadyStatus status;
  final GameAction action;
  final RoomData room;
  final Player? player;
  final bool? iamHost;
  final bool skipIntro;
  final Player? currentPlayer;

  const GamePlayState({
    required this.status,
    required this.action,
    required this.room,
    required this.player,
    required this.iamHost,
    required this.skipIntro,
    required this.currentPlayer,
  });

  GamePlayState.empty()
      : this(
          action: GameAction.prepare,
          status: ReadyStatus.init,
          room: RoomData(),
          player: null,
          iamHost: false,
          skipIntro: false,
          currentPlayer: null,
        );

  GamePlayState copyWith({
    ReadyStatus? status,
    GameAction? action,
    RoomData? room,
    Player? player,
    Player? currentPlayer,
    bool? iamHost,
    bool? skipIntro,
  }) {
    return GamePlayState(
      status: status ?? this.status,
      action: action ?? this.action,
      room: room ?? this.room,
      player: player ?? this.player,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      iamHost: iamHost ?? this.iamHost,
      skipIntro: skipIntro ?? this.skipIntro,
    );
  }

  @override
  List<Object?> get props => [
        status,
        action,
        room,
        player,
        iamHost,
        skipIntro,
        currentPlayer,
      ];
}
