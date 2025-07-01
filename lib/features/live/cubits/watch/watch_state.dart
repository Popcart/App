part of 'watch_cubit.dart';

@freezed
class WatchState with _$WatchState {
  const factory WatchState.initial() = _Initial;
  const factory WatchState.loading() = _Loading;
  const factory WatchState.success(List<FeedItem> liveStreams) = _Success;
  const factory WatchState.error(String message) = _Error;
}

