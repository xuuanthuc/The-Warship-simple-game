part of 'home_cubit.dart';

enum HomeStatus { loading, success, failed }

@injectable
class HomeState extends Equatable {
  final HomeStatus? status;

  const HomeState({this.status});

  HomeState copyWith(HomeStatus? status) {
    return HomeState(status: status);
  }

  @override
  List<Object?> get props => [status];
}
