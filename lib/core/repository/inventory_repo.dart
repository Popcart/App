import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

sealed class InventoryRepo {
  Future<ListApiResponse<ProductCategory>> getProductCategories();
  
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
  
 
}
