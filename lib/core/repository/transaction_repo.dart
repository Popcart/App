import 'package:popcart/core/api/api_helper.dart';

sealed class TransactionRepo {
  Future<ApiResponse<Map<String, dynamic>>> createTransaction({
    required Map<String, dynamic> data
  });

  Future<ApiResponse<void>> updateTransaction({
    required Map<String, dynamic> data,
  });
}

class TransactionRepoImpl implements TransactionRepo {
  TransactionRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<Map<String, dynamic>>> createTransaction({required Map<String, dynamic> data}) {
    return _apiHelper.request<Map<String, dynamic>>(
      path: 'createTransaction',
      method: MethodType.post,
      payload: data,
      responseMapper: (json) => json,
    );
  }

  @override
  Future<ApiResponse<void>> updateTransaction({required Map<String, dynamic> data}) {
    return _apiHelper.request<void>(
      path: 'updateStatus',
      method: MethodType.patch,
      payload: data
    );
  }

}
