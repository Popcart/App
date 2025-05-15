import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/models/variant_model.dart';

part 'product_cubit.freezed.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<AddProductState> {
  ProductCubit()
      : _inventoryRepo = locator<InventoryRepo>(),
        super(const AddProductState.initial());

  late final InventoryRepo _inventoryRepo;
  List<ProductCategory> interestsList = [];

  Future<void> getInterests() async {
    emit(const AddProductState.loading());
    final response = await _inventoryRepo.getProductCategories();
    response.when(
      success: (interests) {
        interestsList = interests?.data ?? [];
        emit(AddProductState.loaded(interests?.data ?? []));
      },
      error: (error) {
        emit(AddProductState.error(error.message ?? 'An error occurred'));
      },
    );
  }

  // Future<PaginationResponse<Product>> getProducts({required int pageKey}) async {
  //   final response = await _inventoryRepo.getAllProducts(
  //     page: pageKey,
  //     limit: 10,
  //   );
  //
  //   return response.when(
  //     success: (data) => data!.data!,
  //     error: (error) => error,
  //   );
  // }

  Future<void> getProductCategories() async {
    emit(const AddProductState.loading());
    final response = await _inventoryRepo.getProductCategories();
    response.when(
      success: (interests) {
        interestsList = interests?.data ?? [];
        emit(AddProductState.loaded(interests?.data ?? []));
      },
      error: (error) {
        emit(AddProductState.error(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> addProduct({
    required String productName,
    required String productDescription,
    required String productPrice,
    required String discount,
    required String salesPrice,
    required bool status,
    required int stockUnit,
    required List<XFile> images,
    required List<VariantModel> variants,
    required ProductCategory category,
  }) async {
    emit(const AddProductState.loading());
    final response = await _inventoryRepo.uploadProduct(
      productName: productName,
      productDesc: productDescription,
      category: category.id,
      price: int.parse(productPrice),
      salesPrice: salesPrice,
      discount: discount,
      selling: status,
      stockUnit: stockUnit,
      productImages: images,
      productVariant: variants,
    );
    response.when(
      success: (interests) {
        emit(const AddProductState.saveProduct());
      },
      error: (error) {
        emit(AddProductState.saveProductFailure(
            error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> editProduct({
    required String productId,
    required String productName,
    required String productDescription,
    required String productPrice,
    required String discount,
    required String salesPrice,
    required bool status,
    required int stockUnit,
    required List<VariantModel> variants,
    required ProductCategory category,
  }) async {
    emit(const AddProductState.loading());
    final response = await _inventoryRepo.editProduct(
      productId: productId,
      productName: productName,
      productDesc: productDescription,
      category: category.id,
      price: int.parse(productPrice),
      salesPrice: salesPrice,
      discount: discount,
      selling: status,
      stockUnit: stockUnit,
      productVariant: variants,
    );
    response.when(
      success: (interests) {
        emit(const AddProductState.saveProduct());
      },
      error: (error) {
        emit(AddProductState.saveProductFailure(
            error.message ?? 'An error occurred'));
      },
    );
  }

  Future<ApiResponse<void>> deleteProduct({
    required String productId,
  }) async {
    emit(const AddProductState.deletingProduct());
    final response = await _inventoryRepo.deleteProduct(
      productId: productId,
    );
    response.when(
      success: (message) {
        emit(AddProductState.deleteProductSuccess(
            message?.message ?? 'Product deleted successfully'));
      },
      error: (error) {
        emit(AddProductState.error(error.message ?? 'An error occurred'));
      },
    );
    return response;
  }
}
