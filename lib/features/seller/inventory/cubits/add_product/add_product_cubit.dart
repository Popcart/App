import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/models/variant_model.dart';

part 'add_product_cubit.freezed.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit()
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

  Future<void> addProduct({
    required String productName,
    required String productDescription,
    required String productPrice,
    required String discount,
    required String salesPrice,
    required bool status,
    required List<XFile> images,
    required List<VariantModel> variants,
    required ProductCategory category,
}) async {

  }
}
