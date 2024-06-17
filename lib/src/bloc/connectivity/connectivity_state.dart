part of 'connectivity_bloc.dart';

@immutable
class ConnectivityState extends Equatable {
  final ConnectivityResult result;

  const ConnectivityState({required this.result});

  @override
  List<Object?> get props => [result];
}
