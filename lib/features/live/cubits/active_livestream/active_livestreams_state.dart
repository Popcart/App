part of 'active_livestreams_cubit.dart';

@freezed
class ActiveLivestreamsState with _$ActiveLivestreamsState {
  const factory ActiveLivestreamsState.initial() = _ActiveInitial;
  const factory ActiveLivestreamsState.loading() = _ActiveLoading;
  const factory ActiveLivestreamsState.success(List<LiveStream> liveStreams) = _ActiveSuccess;
  const factory ActiveLivestreamsState.error(String message) = _ActiveError;
}

@freezed
class ScheduledLivestreamsState with _$ScheduledLivestreamsState {
  const factory ScheduledLivestreamsState.initial() = _ScheduledInitial;
  const factory ScheduledLivestreamsState.loading() = _ScheduledLoading;
  const factory ScheduledLivestreamsState.success(List<LiveStream> liveStreams) = _ScheduledSuccess;
  const factory ScheduledLivestreamsState.error(String message) = _ScheduledError;
}

