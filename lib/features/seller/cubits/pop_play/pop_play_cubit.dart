import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/pop_play_repo.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';

part 'pop_play_state.dart';

part 'pop_play_cubit.freezed.dart';

class PopPlayCubit extends Cubit<PopPlayState> {
  PopPlayCubit()
      : _popPlayRepo = locator<PopPlayRepo>(),
        super(const PopPlayState.initial());
  late final PopPlayRepo _popPlayRepo;

  Future<void> uploadPost({
    required String video,
    required String caption,
  }) async {
    emit(const PopPlayState.loading());
    final response = await _popPlayRepo.uploadPost(
      video: video,
      caption: caption,
    );
    response.when(
      success: (_) {
        emit(const PopPlayState.uploadSuccess());
      },
      error: (error) {
        emit(PopPlayState.uploadError(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> getPosts({
    required String userId,
  }) async {
    emit(const PopPlayState.loading());
    final response = await _popPlayRepo.getPosts(
      userId: userId,
      page: 1,
      limit: 20,
    );
    response.when(
      success: (posts) {
        emit(PopPlayState.loaded(posts?.data?.posts ?? <VideoPost>[]));
      },
      error: (error) {
        emit(PopPlayState.uploadError(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> deletePosts({
    required String postId,
    required List<VideoPost> existingPosts,
  }) async {
    emit(const PopPlayState.deletePost());
    final response = await _popPlayRepo.deletePosts(postId: postId);
    response.when(
      success: (_) {
        final updatedPosts =
            existingPosts.where((post) => post.id != postId).toList();
        emit(PopPlayState.loaded(updatedPosts));
      },
      error: (error) {
        emit(
            PopPlayState.postDeleteError(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> markVideoAsWatched({
    required String postId,
  }) async {
    await _popPlayRepo.markVideoAsWatched(postId: postId);
  }
}
