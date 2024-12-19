import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/features/onboarding/repository/onboarding_repo.dart';

part 'onboarding_cubit.freezed.dart';
part 'onboarding_state.dart';

@JsonEnum()
enum UserType {
  @JsonValue('buyer')
  buyer,
  @JsonValue('seller')
  seller
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
      : _onboardingRepo = locator.get<OnboardingRepo>(),
        super(const OnboardingState.initial());

  late final OnboardingRepo _onboardingRepo;

  late String _firstName;
  late String _lastName;
  late String _email;
  late String _username;
  late String _phoneNumber;
  late String _businessName;
  late String _rcNumber;
  late String _businessOwnerBvn;
  late String _businessAddress;
  late UserType _userType;
  late bool _isRegisteredSeller;

  set firstName(String value) {
    _firstName = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set email(String value) {
    _email = value;
  }

  set userType(UserType value) {
    _userType = value;
  }

  set isRegisteredSeller(bool value) {
    _isRegisteredSeller = value;
  }

  set username(String value) {
    _username = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set businessName(String value) {
    _businessName = value;
  }

  set rcNumber(String value) {
    _rcNumber = value;
  }

  set businessOwnerBvn(String value) {
    _businessOwnerBvn = value;
  }

  set businessAddress(String value) {
    _businessAddress = value;
  }

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  UserType get userType => _userType;
  bool get isRegisteredSeller => _isRegisteredSeller;
  String get username => _username;
  String get phoneNumber => _phoneNumber;
  String get businessName => _businessName;
  String get rcNumber => _rcNumber;
  String get businessOwnerBvn => _businessOwnerBvn;
  String get businessAddress => _businessAddress;

  Future<void> registerBuyer() async {
    emit(const OnboardingState.loading());
    final response = await _onboardingRepo.setOnboardingCompleted(
      firstName: _firstName,
      lastName: _lastName,
      username: _username,
      phone: _phoneNumber,
      email: _email,
      userType: 'buyer',
    );
    response.when(
      success: (data) {
        emit(const OnboardingState.onboardingSuccess());
      },
      error: (e) {
        emit(
          OnboardingState.onboardingFailure(
            e.message ?? 'An error occurred',
          ),
        );
      },
    );
  }

  Future<void> verifyOtp({
    required String otp,
  }) async {
    emit(const OnboardingState.loading());
    final response = await _onboardingRepo.verifyOtp(
      otp: otp,
    );
    response.when(
      success: (data) {
        emit(const OnboardingState.verifyOtpSuccess());
      },
      error: (e) {
        emit(
          OnboardingState.verifyOtpFailure(
            e.message ?? 'An error occurred',
          ),
        );
      },
    );
  }
}
