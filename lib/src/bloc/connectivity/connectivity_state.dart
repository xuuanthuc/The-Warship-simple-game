part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityChangedState extends ConnectivityState {
  final ConnectivityResult result;

  const ConnectivityChangedState(this.result);

  @override
  List<Object?> get props => [result];
}
