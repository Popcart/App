part of 'cart_cubit.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = _Initial;
  const factory CartState.loading() = _Loading;
  const factory CartState.getCartSuccess(List<CartItemModel> carts) = _GetCartSuccess;
  const factory CartState.getCartError(String error) = _GetCartError;
  const factory CartState.deletingCartItem() = _DeletingCartItem;
  const factory CartState.addingToCart() = _AddingToCart;
  const factory CartState.cartAddedSuccess() = _CartAddedSuccess;
  const factory CartState.cartAddingError(String error) = _CartAddingError;

  const factory CartState.updateCartSuccess() = _UpdateCartSuccess;
  const factory CartState.updateCartError(String error) = _UpdateCartError;

  const factory CartState.processingOrder() = _ProcessingOrder;
  const factory CartState.orderProcessed() = _OrderProcessed;
  const factory CartState.processingOrderError(String error) = _ProcessingOrderError;
}
