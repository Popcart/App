import 'dart:io';

import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/user/models/user_model.dart';

sealed class UserRepository {
  Future<ApiResponse<void>> submitRegisteredBusinessInformation({
    required String businessName,
    required String rcNumber,
    required String businessOwnerBvn,
    required String businessAddress,
    required File utilityBillDocument,
    required File idDocument,
  });
  Future<ApiResponse<UserModel>> getUserProfile();
 
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<void>> submitRegisteredBusinessInformation({
    required String businessName,
    required String rcNumber,
    required String businessOwnerBvn,
    required String businessAddress,
    required File utilityBillDocument,
    required File idDocument,
  }) async {
    return _apiHelper.request<void>(
      path: 'edit-business-profile',
      method: MethodType.patch,
      payload: {
        'businessName': businessName,
        'cacNumber': rcNumber,
        'bvn': businessOwnerBvn,
        'businessAddress': businessAddress,
      },
      files: {
        'utilityBill': utilityBillDocument,
        'idCard': idDocument,
      },
    );
  }

  @override
  Future<ApiResponse<UserModel>> getUserProfile() {
    return _apiHelper.request<UserModel>(
      path: 'profile',
      method: MethodType.get,
      responseMapper: UserModel.fromJson,
    );
  }


}
