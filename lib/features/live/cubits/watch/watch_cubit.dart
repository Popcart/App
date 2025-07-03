import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/pop_play_repo.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';

part 'watch_cubit.freezed.dart';
part 'watch_state.dart';

class WatchCubit extends Cubit<WatchState> {
  WatchCubit()
      : _popPlayRepo = locator<PopPlayRepo>(),
        super(const WatchState.initial());

  late final PopPlayRepo _popPlayRepo;

  Future<void> getAllPostsAndLiveStreams() async {
    emit(const WatchState.loading());
    final response = await _popPlayRepo.getAllPostAndLiveStreams();
    response.when(
      success: (data) {
        final feed = <FeedItem>[];
        for (final video in data?.data?.posts?? <VideoPost>[]) {
          feed.add(video);
        }
        for (final liveStream in data?.data?.livestreams?? <LiveStream>[]) {
          feed.add(liveStream);
        }
        feed.sort((a, b) {
          final aDate = a is VideoPost ? a.createdAt : (a as LiveStream).createdAt;
          final bDate = b is VideoPost ? b.createdAt : (b as LiveStream).createdAt;
          return bDate.compareTo(aDate);
        });

        emit(WatchState.success(feed));
      },
      error: (error) {
        WatchState.error(error.message ?? 'An error occurred');
      },
    );
  }
}
