import 'package:image_picker/image_picker.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';

sealed class PopPlayRepo {
  Future<ApiResponse<void>> uploadPost({
    required String video,
    required String caption,
  });

  Future<ApiResponse<VideoPostData>> getPosts({
    required String userId,
    required int page,
    required int limit,
  });

  Future<ApiResponse<void>> deletePosts({
    required String postId,
  });

  Future<ApiResponse<void>> markVideoAsWatched({
    required String postId,
  });

  Future<ApiResponse<VideoPostData>> getAllPostAndLiveStreams();
}

class PopPlayRepoImpl implements PopPlayRepo {
  PopPlayRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<void>> uploadPost({
    required String video,
    required String caption,
  }) async {
    return _apiHelper.request(
      path: 'create',
      method: MethodType.post,
      payload: {
        'caption': caption,
      },
      imagesKey: 'video',
      singleFile: XFile(Uri.parse(video).path),
    );
  }

  @override
  Future<ApiResponse<VideoPostData>> getPosts({
    required String userId,
    required int page,
    required int limit,
  }) async {
    return _apiHelper.request<VideoPostData>(
      path: '',
      method: MethodType.get,
      queryParameters: {
        'userId': userId,
        'page': page,
        'limit': limit,
      },
      responseMapper: VideoPostData.fromJson,
    );
  }

  @override
  Future<ApiResponse<void>> deletePosts({required String postId}) {
    return _apiHelper.request<VideoPostData>(
      path: postId,
      method: MethodType.delete,
    );
  }

  @override
  Future<ApiResponse<VideoPostData>> getAllPostAndLiveStreams() {
    return _apiHelper.request<VideoPostData>(
      path: 'all',
      method: MethodType.get,
      responseMapper: VideoPostData.fromJson,
    );
  }

  @override
  Future<ApiResponse<void>> markVideoAsWatched({required String postId}) {
    return _apiHelper.request<VideoPostData>(
      path: postId,
      queryParameters: {'postId': postId},
      method: MethodType.get,
    );
  }
}
