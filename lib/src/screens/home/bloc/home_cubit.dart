import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../models/response/post.dart';
import '../../../repositories/post_repository.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final PostRepository _postRepository;

  HomeCubit(this._postRepository) : super(const HomeState());

  getPosts() async {
    emit(state.copyWith(HomeStatus.loading));
    List<PostData> posts = [];
    try {
      posts = await _postRepository.getPosts();
    } catch (_) {}
    emit(state.copyWith(HomeStatus.success));
  }
}
