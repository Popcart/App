import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/live/models/search_model.dart';

sealed class ProductsRepo {
  Future<ApiResponse<PaginationResponse<Product>>> getProducts({
    required int page,
    required int limit,
  });

  Future<ApiResponse<SearchData>> searchProduct({
    required String productName,
    required int page,
    required int limit,
  });

  Future<ApiResponse<Product>> getProductDetails({
    required String productId,
  });
}

class ProductsRepoImpl implements ProductsRepo {
  ProductsRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<PaginationResponse<Product>>> getProducts({
    required int page,
    required int limit,
  }) async {
    return _apiHelper.request<PaginationResponse<Product>>(
      path: '',
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
      path: productId,
      method: MethodType.get,
      responseMapper: Product.fromJson,
    );
  }

  @override
  Future<ApiResponse<SearchData>> searchProduct(
      {required String productName, required int page, required int limit}) async {
    return _apiHelper.request<SearchData>(
      path: 'search',
      method: MethodType.get,
      queryParameters: {
        'search': productName,
        'page': page,
        'limit': limit,
      },
      responseMapper: (v) {
        return SearchData.fromJson(v);
      },
    );
  }
}
