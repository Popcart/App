import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/features/user/models/user_model.dart';

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
      success: (user) =>
          emit(ProfileState.loaded(user?.data ?? UserModel.empty())),
      error: (error) =>
          emit(ProfileState.error(error.message ?? 'An error occurred')),
    );
  }
}
