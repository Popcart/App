part of 'onboarding_cubit.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.loading() = _Loading;
  const factory OnboardingState.onboardingSuccess() = _OnboardingSuccess;
  const factory OnboardingState.onboardingFailure(String message) =
      _OnboardingFailure;
}
