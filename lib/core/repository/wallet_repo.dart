import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/api/pagination.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/wallet/model/wallet_model.dart';

sealed class WalletRepo {
  Future<ApiResponse<WalletModel>> getWalletInfo({
    required String userId,
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

}
