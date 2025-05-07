part of 'add_product_cubit.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState.initial() = _Initial;
  const factory AddProductState.loading() = _Loading;
  const factory AddProductState.loaded(List<ProductCategory> interests) =
  _Loaded;
  const factory AddProductState.error(String message) = _Error;

  const factory AddProductState.saveProduct() = _SaveProductSuccess;
  const factory AddProductState.saveProductFailure(String message) =_SaveProductFailure;
}