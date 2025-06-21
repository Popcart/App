part of 'open_livestream_cubit.dart';

@freezed
class OpenLivestreamState with _$OpenLivestreamState {
  const factory OpenLivestreamState.initial() = _Initial;
  const factory OpenLivestreamState.loading() = _Loading;
  const factory OpenLivestreamState.success({
    required Stream stream,
  }) = _Success;
  const factory OpenLivestreamState.error(String message) = _Error;
}
