import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class SellersRepo {
  Future<ApiResponse<PaginationResponse<Product>>> getProducts({
    required String userId,
    required int page,
    required int limit,
  });
  Future<ApiResponse<Product>> getProduct({
    required String productId,
  });
}

class SellersRepoImpl implements SellersRepo {
  SellersRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<PaginationResponse<Product>>> getProducts({
    required String userId,
    required int page,
    required int limit,
  }) async {
    return _apiHelper.request<PaginationResponse<Product>>(
      path: '$userId/products',
      method: MethodType.get,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      responseMapper: (v) {
        return PaginationResponse<Product>.fromJson(
          v,
          (i) => Product.fromJson(i! as Map<String, dynamic>),
          'products',
        );
      },
    );
  }

  @override
  Future<ApiResponse<Product>> getProduct({required String productId}) {
    return _apiHelper.request<Product>(
      path: 'products/$productId',
      method: MethodType.get,
      responseMapper: Product.fromJson,
    );
  }
}
