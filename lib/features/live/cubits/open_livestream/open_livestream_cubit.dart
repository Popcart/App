import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/features/live/models/products.dart';

part 'open_livestream_cubit.freezed.dart';
part 'open_livestream_state.dart';

class OpenLivestreamCubit extends Cubit<OpenLivestreamState> {
  OpenLivestreamCubit()
      : _livestreamsRepo = locator<LivestreamsRepo>(),
        super(const OpenLivestreamState.initial());

  late final LivestreamsRepo _livestreamsRepo;

  Future<void> createLivestreamSession({
    required String name,
    required List<String> products,
    required bool scheduled,
    String? startTime,
  }) async {
    emit(const OpenLivestreamState.loading());
    final response = await _livestreamsRepo.createLivestreamSession(
      name: name,
      products: products,
      scheduled: scheduled,
      startTime: startTime,
    );
    response.when(
      success: (data) {
        emit(
          OpenLivestreamState.success(
            liveStream: data?.data ?? LiveStream.empty(),
          ),
        );
      },
      error: (error) {
        emit(OpenLivestreamState.error(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> generateAgoraToken() async {
    final response = await _livestreamsRepo.generateAgoraToken();
    response.when(
      success: (data) {
        emit(OpenLivestreamState.generateTokenSuccess(data?.data ?? ''));
      },
      error: (error) {
        emit(
          OpenLivestreamState.generateTokenError(
            error.message ?? 'An error occurred',
          ),
        );
      },
    );
  }
}
