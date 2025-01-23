import 'dart:io';

import 'package:popcart/core/api/api_helper.dart';

sealed class UserRepository{
  Future<ApiResponse<void>> submitRegisteredBusinessInformation({
    required String businessName,
    required String rcNumber,
    required String businessOwnerBvn,
    required String businessAddress,
    required File utilityBillDocument,
    required File idDocument,
  });
  
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
  }}
