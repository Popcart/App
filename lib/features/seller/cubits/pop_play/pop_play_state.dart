part of 'pop_play_cubit.dart';

@freezed
class PopPlayState with _$PopPlayState {
  const factory PopPlayState.initial() = _Initial;
  const factory PopPlayState.loading() = _Loading;
  const factory PopPlayState.uploadPost() = _UploadPost;
  const factory PopPlayState.uploadSuccess() = UploadSuccess;
  const factory PopPlayState.uploadError(String error) = _UploadError;
  const factory PopPlayState.loaded(List<VideoPost> posts) = _Loaded;

  const factory PopPlayState.deletePost() = _DeletingPost;
  const factory PopPlayState.postDeleted() = _PostDeleted;
  const factory PopPlayState.postDeleteError(String error) = _PostDeleteError;
}
