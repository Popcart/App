import 'package:image_picker/image_picker.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class LivestreamsRepo {
  Future<ApiResponse<LiveStream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    required XFile thumbnail, String? startTime,
  });

  Future<ApiResponse<String>> generateAgoraToken({
    required String channelName,
    required int agoraRole,
    required int uid,
  });

  Future<ApiResponse<String>> generateAgoraRTMToken({
    required String userId,
  });

  Future<ListApiResponse<LiveStream>> getActiveLivestreams();

  Future<ListApiResponse<LiveStream>> getScheduledLivestreams();

  Future<ApiResponse<void>> setSellerAgoraId({
    required String agoraId,
    required String livestreamId,
  });

  Future<ApiResponse<void>> endLivestreamSession({
    required String livestreamId,
    required bool isEnding
  });
}

class LivestreamsRepoImpl extends LivestreamsRepo {
  LivestreamsRepoImpl(this._apiHandler);

  final ApiHandler _apiHandler;

  @override
  Future<ApiResponse<LiveStream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    required XFile thumbnail, String? startTime,
  }) async {
    return _apiHandler.request<LiveStream>(
      path: '',
      method: MethodType.post,
      payload: {
        'title': name,
        'products': products,
        'scheduled': scheduled,
        if (startTime != null) 'startTime': startTime,
      },
      singleFile: thumbnail,
      imagesKey: 'thumbnail',
      responseMapper: LiveStream.fromJson,
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
  Future<ApiResponse<String>> generateAgoraRTMToken({
    required String userId,
  }) {
    return _apiHandler.request<String>(
      path: 'generate-rtm-token',
      queryParameters: {
        'userId': userId,
      },
      method: MethodType.get,
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
  Future<ListApiResponse<LiveStream>> getScheduledLivestreams() {
    return _apiHandler.requestList<LiveStream>(
      path: 'scheduled',
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
    required bool isEnding,
  }) {
    return _apiHandler.request<void>(
      path: isEnding ? '$livestreamId/end' : '$livestreamId/start',
      method: MethodType.put,
    );
  }
}
