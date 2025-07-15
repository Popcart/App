import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/features/live/models/products.dart';

part 'active_livestreams_cubit.freezed.dart';

part 'active_livestreams_state.dart';

class ActiveLivestreamsCubit extends Cubit<ActiveLivestreamsState> {
  ActiveLivestreamsCubit()
      : _livestreamsRepo = locator<LivestreamsRepo>(),
        super(const ActiveLivestreamsState.initial());

  late final LivestreamsRepo _livestreamsRepo;

  Future<void> getActiveLivestreams() async {
    emit(const ActiveLivestreamsState.loading());
    final response = await _livestreamsRepo.getActiveLivestreams();
    response.when(
      success: (data) {
        emit(ActiveLivestreamsState.success(data?.data ?? <LiveStream>[]));
      },
      error: (error) {
        emit(
          ActiveLivestreamsState.error(error.message ?? 'An error occurred'),
        );
      },
    );
  }
}

class ScheduledLivestreamsCubit extends Cubit<ScheduledLivestreamsState> {
  ScheduledLivestreamsCubit()
      : _livestreamsRepo = locator<LivestreamsRepo>(),
        super(const ScheduledLivestreamsState.initial());

  final LivestreamsRepo _livestreamsRepo;

  Future<void> getScheduledLivestreams() async {
    emit(const ScheduledLivestreamsState.loading());
    final response = await _livestreamsRepo.getScheduledLivestreams();
    response.when(
      success: (data) {
        emit(ScheduledLivestreamsState.success(data?.data ?? []));
      },
      error: (error) {
        emit(ScheduledLivestreamsState.error(
            error.message ?? 'An error occurred'));
      },
    );
  }
}
