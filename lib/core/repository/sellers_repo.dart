import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/models/user_model.dart';

sealed class SellersRepo {
  Future<ApiResponse<PaginationResponse<Product>>> getProducts({
    required String userId,
    required int page,
    required int limit,
  });

  Future<ApiResponse<Product>> getProductDetails({
    required String productId,
  });

  Future<ApiResponse<PaginationResponse<UserModel>>> getSellers({
    required int page,
    required int limit,
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
  Future<ApiResponse<Product>> getProductDetails({required String productId}) {
    return _apiHelper.request<Product>(
      path: 'products/$productId',
      method: MethodType.get,
      responseMapper: Product.fromJson,
    );
  }

  @override
  Future<ApiResponse<PaginationResponse<UserModel>>> getSellers(
      {required int page, required int limit}) async {
    return _apiHelper.request<PaginationResponse<UserModel>>(
      path: '',
      method: MethodType.get,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      responseMapper: (v) {
        return PaginationResponse<UserModel>.fromJson(
          v,
          (i) => UserModel.fromJson(i! as Map<String, dynamic>),
          'sellers',
        );
      },
    );
  }
}
