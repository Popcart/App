part of 'active_livestreams_cubit.dart';

@freezed
class ActiveLivestreamsState with _$ActiveLivestreamsState {
  const factory ActiveLivestreamsState.initial() = _Initial;
  const factory ActiveLivestreamsState.loading() = _Loading;
  const factory ActiveLivestreamsState.success(List<LiveStream> liveStreams) = _Success;
  const factory ActiveLivestreamsState.error(String message) = _Error;
}
