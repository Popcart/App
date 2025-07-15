import 'dart:io';

import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/common/models/user_model.dart';

sealed class UserRepository {
  Future<ApiResponse<void>> submitRegisteredBusinessInformation({
    required String businessName,
    required String rcNumber,
    required String businessOwnerBvn,
    required String businessAddress,
    required File utilityBillDocument,
    required File idDocument,
  });

  Future<ApiResponse<void>> submitIndividualBusinessInformation({
    required String bvn,
    String? businessEmail,
    String? businessName,
  });

  Future<ApiResponse<UserModel>> getUserProfile();

  Future<ApiResponse<dynamic>> saveInterest(List<String> interests);

  Future<ApiResponse<void>> saveFcmToken(String deviceToken);
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

  @override
  Future<ApiResponse<void>> submitIndividualBusinessInformation({
    required String bvn,
    String? businessEmail,
    String? businessName,
  }) {
    return _apiHelper.request<void>(
      path: 'edit-business-profile',
      method: MethodType.patch,
      payload: {
        'businessName': businessName,
        'bvn': bvn,
        'businessAddress': businessEmail,
      },
    );
  }

  @override
  Future<ApiResponse<void>> saveInterest(List<String> interests) async {
    final response = await _apiHelper.request<void>(
      path: 'edit-profile',
      method: MethodType.put,
      payload: {
        'interests': interests,
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<void>> saveFcmToken(String deviceToken) async {
    final response = await _apiHelper.request<void>(
      path: 'save-device-token',
      method: MethodType.post,
      payload: {
        'deviceToken': deviceToken,
      },
    );
    return response;
  }
}
