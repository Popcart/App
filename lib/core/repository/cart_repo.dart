import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class CartRepo {
  Future<ListApiResponse<CartItemModel>> getCart({
    required String userId,
  });

  Future<ApiResponse<void>> addProductToCart({
    required CartItemModel cartItem,
  });

  Future<ApiResponse<void>> updateCartItem({
    required CartItemModel cartItem,
  });

  Future<ApiResponse<void>> deleteCartItem({
    required CartItemModel cartItem,
  });

  Future<ApiResponse<void>> clearCart({required String userId,});
}

class CartRepoImpl implements CartRepo {
  CartRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ListApiResponse<CartItemModel>> getCart({
    required String userId,
}) async {
    return _apiHelper.requestList<CartItemModel>(
      path: 'cart/$userId',
      method: MethodType.get,
      responseMapper: CartItemModel.fromJson
    );
  }

  @override
  Future<ApiResponse<void>> addProductToCart({required CartItemModel cartItem}) {
    return _apiHelper.request<Product>(
      path: 'cart/add',
      method: MethodType.post,
      payload: {
        'userId': cartItem.userId,
        'productId': cartItem.productId,
        'quantity': cartItem.quantity,
        'variant': cartItem.variant,
        'meta': cartItem.meta.toJson()
      }
    );
  }

  @override
  Future<ApiResponse<void>> updateCartItem({required CartItemModel cartItem}) {
    return _apiHelper.request<Product>(
      path: 'cart/update/${cartItem.id}',
      method: MethodType.patch,
      payload: cartItem.toJson()
    );
  }

  @override
  Future<ApiResponse<void>> deleteCartItem({required CartItemModel cartItem}) {
    return _apiHelper.request<Product>(
      path: 'cart/remove/${cartItem.id}',
      method: MethodType.delete,
    );
  }

  @override
  Future<ApiResponse<void>> clearCart({required String userId,}) {
    return _apiHelper.request<Product>(
      path: 'cart/clear/$userId',
      method: MethodType.delete,
    );
  }

}
