import 'package:injectable/injectable.dart';

import './../../src/models/response/post.dart';
import './../../src/network/endpoint.dart';

import '../di/dependencies.dart';
import '../network/api_provider.dart';

@injectable
@lazySingleton
class PostRepository {
  final ApiProvider _apiProvider = getIt.get<ApiProvider>();

  Future<List<PostData>> getPosts() async {
    List<PostData> posts = [];
    final res = await _apiProvider.get(ApiEndpoint.post);
    res['data'].forEach((e) => posts.add(PostData.fromJson(e)));
    return posts;
  }
}
