import 'dart:io';

import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

sealed class OnboardingRepo {
  Future<ApiResponse<RegisterResponse>> setOnboardingCompleted({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String userType,
  });

  Future<ApiResponse<void>> verifyOtp({required String otp});


}

class OnboardingRepoImpl implements OnboardingRepo {
  OnboardingRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<RegisterResponse>> setOnboardingCompleted({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String userType,
  }) async {
    return _apiHelper.request(
      path: 'register',
      method: MethodType.post,
      responseMapper: RegisterResponse.fromJson,
      payload: {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        'userType': userType,
      },
    );
  }

  @override
  Future<ApiResponse<void>> verifyOtp({required String otp}) {
    return _apiHelper.request<void>(
      path: 'verify-phone',
      method: MethodType.post,
      payload: {
        'code': otp,
      },
    );
  }

}
