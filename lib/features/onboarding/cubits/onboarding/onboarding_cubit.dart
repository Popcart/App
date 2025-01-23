import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/onboarding_repo.dart';
import 'package:popcart/core/repository/user_repo.dart';

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
        _userRepository = locator.get<UserRepository>(),
        super(const OnboardingState.initial());

  late final OnboardingRepo _onboardingRepo;
  late final UserRepository _userRepository;

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
      phone: _phoneNumber,
    );
    response.when(
      success: (data) {
         locator<SharedPrefs>()..accessToken = data?.data?.token ?? ''
         ..refreshToken = data?.data?.refreshToken ?? '';
        locator.setApiHandlerToken(data?.data?.token ?? '');
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

  Future<void> submitRegisteredBusinessInformation({
    required String businessName,
    required String rcNumber,
    required String businessOwnerBvn,
    required String businessAddress,
    required File utilityBillDocument,
    required File idDocument,
  }) async {
    emit(const OnboardingState.loading());
    final response = await _userRepository.submitRegisteredBusinessInformation(
      businessName: businessName,
      rcNumber: rcNumber,
      businessOwnerBvn: businessOwnerBvn,
      businessAddress: businessAddress,
      utilityBillDocument: utilityBillDocument,
      idDocument: idDocument,
    );
    response.when(
      success: (data) {
        emit(
          const OnboardingState.submitRegisteredBusinessInformationSuccess(),
        );
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

  Future<void> sendOtp() async {
    emit(const OnboardingState.loading());
    final response = await _onboardingRepo.sendOtp(
      phone: _phoneNumber,
    );
    response.when(
      success: (data) {
       
        emit(const OnboardingState.sendOtpSuccess());
      },
      error: (e) {
        emit(
          OnboardingState.sendOtpFailure(
            e.message ?? 'An error occurred',
          ),
        );
      },
    );
  }
}
