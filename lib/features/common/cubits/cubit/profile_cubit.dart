import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/features/common/models/user_model.dart';

part 'profile_cubit.freezed.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : _userRepository = locator<UserRepository>(),
        super(const ProfileState.initial());

  late final UserRepository _userRepository;

  Future<void> fetchUserProfile() async {
    emit(const ProfileState.loading());
    final response = await _userRepository.getUserProfile();
    response.when(
      success: (user) {
        locator<SharedPrefs>().userUid = user?.data?.id ?? '';
        locator<SharedPrefs>().username = user?.data?.username ?? '';
        locator<SharedPrefs>().email = user?.data?.email ?? '';
        emit(ProfileState.loaded(user?.data ?? UserModel.empty()));
      },
      error: (error) =>
          emit(ProfileState.error(error.message ?? 'An error occurred')),
    );
  }

  Future<void> saveFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    await _userRepository.saveFcmToken(fcmToken??'');
  }
}
