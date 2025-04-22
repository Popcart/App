import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

sealed class OnboardingRepo {
  Future<ApiResponse<void>> setOnboardingCompleted({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String userType,
    required String businessName,
    required bool registeredBusiness,
  });

  Future<ApiResponse<void>> sendOtp({
    required String email,
  });

  Future<ApiResponse<TokenPair>> verifyOtp({
    required String otp,
    required String email,
    required bool isLoggingIn,
  });

   Future<ApiResponse<void>> verifyEmail({
    required String email,
  });

  Future<ApiResponse<void>> verifyUsername({
    required String username,
  });
}

class OnboardingRepoImpl implements OnboardingRepo {
  OnboardingRepoImpl(this._apiHelper);

  final ApiHandler _apiHelper;

  @override
  Future<ApiResponse<void>> setOnboardingCompleted({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String userType,
    required String businessName,
    required bool registeredBusiness,
  }) async {
      return _apiHelper.request<void>(
        path: 'register',
        method: MethodType.post,
        payload: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'phone': phone,
          'email': email,
          'userType': userType,
          'businessName': businessName,
          'registeredBusiness': registeredBusiness,
        },
      );
  }

  @override
  Future<ApiResponse<TokenPair>> verifyOtp({
    required String otp,
    required String email,
    required bool isLoggingIn,
  }) {
    return _apiHelper.request<TokenPair>(
      path: isLoggingIn ? 'verify-login-otp' : 'verify-otp',
      method: MethodType.post,
      payload: {
        'code': otp,
        'email': email,
      }, responseMapper:  TokenPair.fromJson,
    );
  }
  
  @override
  Future<ApiResponse<void>> sendOtp({required String email}) {
    return _apiHelper.request<void>(
      path: 'send-otp',
      method: MethodType.post,
      payload: {
        'email': email,
      },
     
    );
  }

    @override
  Future<ApiResponse<void>> verifyEmail({required String email}) {
    return _apiHelper.request<void>(
      path: 'validate-signup-details',
      method: MethodType.post,
      payload: {
        'email': email,
      },
    );
  }

  @override
  Future<ApiResponse<void>> verifyUsername({required String username}) {
    return _apiHelper.request<void>(
      path: 'validate-signup-details',
      method: MethodType.post,
      payload: {
        'username': username,
      },
    );
  }
}
