import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/models/variant_model.dart';

sealed class InventoryRepo {
  Future<ListApiResponse<ProductCategory>> getProductCategories();

  Future<ApiResponse<void>> uploadProduct({
    required String productName,
    required String productDesc,
    required String category,
    required int price,
    required String salesPrice,
    required String discount,
    required bool selling,
    required int stockUnit,
    required List<XFile> productImages,
    required List<VariantModel> productVariant,
  });

  Future<ApiResponse<PaginationResponse<Product>>> getTopProducts({
    required int page,
    required int limit,
  });

  Future<ApiResponse<PaginationResponse<Product>>> getAllProducts({
    required int page,
    required int limit,
  });

  Future<ApiResponse<Product>> getProduct({
    required String productId,
  });
}

class InventoryRepoImpl implements InventoryRepo {
  InventoryRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ListApiResponse<ProductCategory>> getProductCategories() async {
    return _apiHelper.requestList(
      path: 'product-categories',
      method: MethodType.get,
      responseMapper: ProductCategory.fromJson,
    );
  }

  @override
  Future<ApiResponse<void>> uploadProduct({
    required String productName,
    required String productDesc,
    required String category,
    required int price,
    required String salesPrice,
    required String discount,
    required bool selling,
    required int stockUnit,
    required List<XFile> productImages,
    required List<VariantModel> productVariant,
  }) async {
    return _apiHelper.request(
      path: 'add-product',
      method: MethodType.post,
      payload: {
        'name': productName,
        'category': category,
        'description': productDesc,
        'stockUnit': stockUnit,
        'price': price,
        'variants': productVariant.map((variant) => variant.toJson()).toList(),
      },
      filesList: productImages,
      imagesKey: 'images'
    );
  }

  @override
  Future<ApiResponse<PaginationResponse<Product>>> getTopProducts({
    required int page,
    required int limit,
  }) async {
    return _apiHelper.request<PaginationResponse<Product>>(
      path: 'top-products',
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
  Future<ApiResponse<PaginationResponse<Product>>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    return _apiHelper.request<PaginationResponse<Product>>(
      path: '',
      method: MethodType.get,
      queryParameters: {
        'available': true,
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
      path: productId,
      method: MethodType.get,
      responseMapper: Product.fromJson,
    );
  }
}
