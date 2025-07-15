import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/wallet/model/wallet_model.dart';

sealed class WalletRepo {
  Future<ApiResponse<WalletModel>> getWalletInfo({
    required String userId,
  });
  Future<ApiResponse<void>> fundWallet({
    required Map<String, dynamic> map,
  });

  Future<ApiResponse<void>> debitWallet({
    required Map<String, dynamic> map,
  });
}

class WalletRepoImpl implements WalletRepo {
  WalletRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<WalletModel>> getWalletInfo({required String userId}) {
    return _apiHelper.request<WalletModel>(
      path: 'getWallet/$userId',
      method: MethodType.get,
      responseMapper: WalletModel.fromJson,
    );
  }

  @override
  Future<ApiResponse<WalletModel>> fundWallet({required Map<String, dynamic> map}) {
    return _apiHelper.request<WalletModel>(
      path: 'fund',
      method: MethodType.post,
      payload: {
        "userId": "user123",
        "amount": 10000,
        "type": "wallet_funding",
        "method": "interswitch",
        "source": "card",
        "destination": "wallet",
        "reference": "ref-20250706-001"
      }
    );
  }

  @override
  Future<ApiResponse<WalletModel>> debitWallet({required Map<String, dynamic> map}) {
    return _apiHelper.request<WalletModel>(
      path: 'debit',
      method: MethodType.post,
      payload: map,
    );
  }

}
