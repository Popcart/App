part of 'interest_list_cubit.dart';

@freezed
class InterestListState with _$InterestListState {
  const factory InterestListState.initial() = _Initial;
  const factory InterestListState.loading() = _Loading;
  const factory InterestListState.loaded(List<ProductCategory> interests) = _Loaded;
  const factory InterestListState.error(String message) = _Error;
}
