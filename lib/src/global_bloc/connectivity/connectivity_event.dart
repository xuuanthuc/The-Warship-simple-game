part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class ConnectivityChangedEvent extends ConnectivityEvent{
  final ConnectivityResult result;

  const ConnectivityChangedEvent(this.result);

  @override
  List<Object?> get props => [result];
}
