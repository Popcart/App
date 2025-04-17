import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/onboarding_repo.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/features/user/models/user_model.dart';

part 'onboarding_cubit.freezed.dart';
part 'onboarding_state.dart';

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
  UserType? _userType;
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

  set userType(UserType? value) {
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

  UserType? get userType => _userType;

  bool get isRegisteredSeller => _isRegisteredSeller;

  String get username => _username;

  String get phoneNumber => _phoneNumber;

  String get businessName => _businessName;

  String get rcNumber => _rcNumber;

  String get businessOwnerBvn => _businessOwnerBvn;

  String get businessAddress => _businessAddress;

  bool isLoggingIn = true;
  bool isBusinessRegistered = false;

  Future<void> registerUser() async {
    try {
      emit(const OnboardingState.loading());
      final response = await _onboardingRepo.setOnboardingCompleted(
        firstName: _firstName,
        lastName: _lastName,
        username: _username,
        phone: _phoneNumber,
        email: _email,
        userType: _userType?.name ?? 'buyer',
        businessName: _businessName,
        registeredBusiness: _isRegisteredSeller,
      );
      response.when(
        success: (data) {
          print("Succcess message: $data");
          emit(const OnboardingState.onboardingSuccess());
        },
        error: (e) {
          print("Error message: $e");
          emit(
            OnboardingState.onboardingFailure(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    }catch(e, stackTrace){
      // print(stackTrace);
    }
  }

  Future<void> verifyOtp({
    required String otp,
  }) async {
    emit(const OnboardingState.loading());
    final response = await _onboardingRepo.verifyOtp(
      otp: otp,
      email: _email,
    );
    response.when(
      success: (data) {
        locator<SharedPrefs>()
          ..accessToken = data?.data?.token ?? ''
          ..loggedIn = true
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

  Future<void> sendOtp({bool isResendingOtp = false}) async {
    emit(const OnboardingState.loading());
    final response = await _onboardingRepo.sendOtp(
      email: _email,
    );
    response.when(
      success: (data) {
        if(!isResendingOtp){
          emit(const OnboardingState.sendOtpSuccess());
        }else{
          emit(const OnboardingState.resendOtpSuccess());
        }
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

  Future<void> verifyEmail(String email) async {
    final response = await _onboardingRepo.verifyEmail(
      email: email,
    );
    response.when(
      success: (data) {
        emit(const OnboardingState.verifyEmailSuccess());
      },
      error: (e) {
        emit(
          OnboardingState.verifyEmailFailure(
            e.message ?? 'An error occurred',
          ),
        );
      },
    );
  }

  Future<void> verifyUsername(String username) async {
    final response = await _onboardingRepo.verifyUsername(
      username: username,
    );
    response.when(
      success: (data) {
        emit(const OnboardingState.verifyUsernameSuccess());
      },
      error: (e) {
        emit(
          OnboardingState.verifyUsernameFailure(
            e.message ?? 'An error occurred',
          ),
        );
      },
    );
  }

  Future<void> submitIndividualBusinessInformation({
    required String bvn,
    String? businessEmail,
    String? businessName,
  }) async {
    emit(const OnboardingState.loading());
    final response = await _userRepository.submitIndividualBusinessInformation(
      bvn: bvn,
      businessEmail: businessEmail,
      businessName: businessName,
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
}
