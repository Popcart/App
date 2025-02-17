import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class LivestreamsRepo {
  Future<ApiResponse<LiveStream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    String? startTime,
  });
  Future<ApiResponse<String>> generateAgoraToken();
}

class LivestreamsRepoImpl extends LivestreamsRepo {
  LivestreamsRepoImpl(this._apiHandler);
  final ApiHandler _apiHandler;

  @override
  Future<ApiResponse<LiveStream>> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    String? startTime,
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
      responseMapper: LiveStream.fromJson,
    );
  }

  @override
  Future<ApiResponse<String>> generateAgoraToken() {
    return _apiHandler.request<String>(
      path: 'generate-token',
      method: MethodType.post,
      responseMapper: (json) => json['token'] as String,
    );
  }
}
