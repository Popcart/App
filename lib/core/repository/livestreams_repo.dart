import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class LivestreamsRepo {
  Future<ApiResponse<Stream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    String? startTime,
  });
  Future<ApiResponse<String>> generateAgoraToken({
    required String channelName,
    required int agoraRole,
    required int uid,
  });
  Future<ListApiResponse<LiveStream>> getActiveLivestreams();
  Future<ApiResponse<void>> setSellerAgoraId({
    required String agoraId,
    required String livestreamId,
  });
  Future<ApiResponse<void>> endLivestreamSession({
    required String livestreamId,
  });
}

class LivestreamsRepoImpl extends LivestreamsRepo {
  LivestreamsRepoImpl(this._apiHandler);
  final ApiHandler _apiHandler;

  @override
  Future<ApiResponse<Stream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    String? startTime,
  }) async {
    return _apiHandler.request<Stream>(
      path: '',
      method: MethodType.post,
      payload: {
        'title': name,
        'products': products,
        'scheduled': scheduled,
        if (startTime != null) 'startTime': startTime,
      },
      responseMapper: Stream.fromJson,
    );
  }

  @override
  Future<ApiResponse<String>> generateAgoraToken({
    required String channelName,
    required int agoraRole,
    required int uid,
  }) {
    return _apiHandler.request<String>(
      path: 'generate-token',
      payload: {
        'channelName': channelName,
        'agoraRole': agoraRole,
        'uid': uid,
      },
      method: MethodType.post,
      responseMapper: (json) => json['token'] as String,
    );
  }

  @override
  Future<ListApiResponse<LiveStream>> getActiveLivestreams() {
    return _apiHandler.requestList<LiveStream>(
      path: 'active',
      method: MethodType.get,
      responseMapper: LiveStream.fromJson,
    );
  }

  @override
  Future<ApiResponse<void>> setSellerAgoraId({
    required String agoraId,
    required String livestreamId,
  }) {
    return _apiHandler.request<void>(
      path: 'save-agora-id',
      method: MethodType.post,
      payload: {
        'agoraId': agoraId,
        'livestreamId': livestreamId,
      },
    );
  }

  @override
  Future<ApiResponse<void>> endLivestreamSession({
    required String livestreamId,
  }) {
    return _apiHandler.request<void>(
      path: '$livestreamId/end',
      method: MethodType.put,
    );
  }
}
