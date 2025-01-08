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

  Future<ApiResponse<void>> sendOtp({
    required String phone,
  });

  Future<ApiResponse<String>> verifyOtp({
    required String otp,
    required String phone,
  });
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
  Future<ApiResponse<String>> verifyOtp({
    required String otp,
    required String phone,
  }) {
    return _apiHelper.request<String>(
      path: 'verify-phone',
      method: MethodType.post,
      payload: {
        'code': otp,
        'phone': phone,
      }, responseMapper: (json) {
        
        return json['token'] as String;
      },
    );
  }
  
  @override
  Future<ApiResponse<void>> sendOtp({required String phone}) {
    return _apiHelper.request<void>(
      path: 'send-otp',
      method: MethodType.post,
      payload: {
        'phone': phone,
      },
     
    );
  }
}
