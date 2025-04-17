part of 'onboarding_cubit.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;

  const factory OnboardingState.loading() = _Loading;

  const factory OnboardingState.onboardingSuccess() = _OnboardingSuccess;

  const factory OnboardingState.onboardingFailure(String message) =
      _OnboardingFailure;

  const factory OnboardingState.sendOtpSuccess() = _SendOtpSuccess;

  const factory OnboardingState.resendOtpSuccess() = _ResendOtpSuccess;

  const factory OnboardingState.sendOtpFailure(String message) =
      _SendOtpFailure;

  const factory OnboardingState.verifyOtpSuccess() = _VerifyOtpSuccess;

  const factory OnboardingState.verifyOtpFailure(String message) =
      _VerifyOtpFailure;

  const factory OnboardingState.submitRegisteredBusinessInformationSuccess() =
      _SubmitRegisteredBusinessInformationSuccess;

  const factory OnboardingState.verifyEmailSuccess() = _VerifyEmailSuccess;

  const factory OnboardingState.verifyEmailFailure(String message) =
      _VerifyEmailFailure;

  const factory OnboardingState.verifyUsernameSuccess() =
      _VerifyUsernameSuccess;

  const factory OnboardingState.verifyUsernameFailure(String message) =
      _VerifyUsernameFailure;
}
