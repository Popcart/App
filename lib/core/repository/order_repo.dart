import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/common/models/order_model.dart';
import 'package:popcart/features/live/models/products.dart';

sealed class OrderRepo {
  Future<ListApiResponse<TransactionList>> getBuyerOrders({
    required int page,
    required int limit,
    required String status,
  });

  Future<ListApiResponse<Order>> getSellersOrder({
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
  Future<ListApiResponse<TransactionList>> getBuyerOrders({
    required int page,
    required int limit,
    required String status,
  }) async {
    final pref = locator<SharedPrefs>();
    final userId = pref.userUid;
    return _apiHelper.requestList<TransactionList>(
      path: 'orders/buyer/$userId',
      method: MethodType.get,
      responseMapper: TransactionList.fromJson,
    );
  }
  @override
  Future<ListApiResponse<Order>> getSellersOrder({
    required int page,
    required int limit,
    required String status,
  }) async {
    final pref = locator<SharedPrefs>();
    final userId = pref.userUid;
    return _apiHelper.requestList<Order>(
      path: 'orders/seller/$userId',
      method: MethodType.get,
      responseMapper: Order.fromJson,
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
