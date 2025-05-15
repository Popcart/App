import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class OrderRepo {
  Future<ApiResponse<PaginationResponse<Product>>> getOrders({
    required int page,
    required int limit,
    required String status,
  });

  Future<ApiResponse<void>> getOrderInfo({
    required int id,
  });
}

class OrderRepoImpl implements OrderRepo {
  OrderRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<PaginationResponse<Product>>> getOrders({
    required int page,
    required int limit,
    required String status,
}) async {
    return _apiHelper.request<PaginationResponse<Product>>(
      path: '',
      method: MethodType.get,
      queryParameters: {
        'page': page,
        'limit': limit,
        'status': status
      },
      responseMapper: (v) {
        return PaginationResponse<Product>.fromJson(
          v,
              (i) => Product.fromJson(i! as Map<String, dynamic>),
          'orders',
        );
      },
    );
  }

  @override
  Future<ApiResponse<void>> getOrderInfo({required int id}) {
    return _apiHelper.request<Product>(
      path: '$id',
      method: MethodType.get,
      responseMapper: Product.fromJson,
    );
  }

}
