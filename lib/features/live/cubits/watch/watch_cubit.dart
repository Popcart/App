import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/models/user_model.dart';

part 'watch_cubit.freezed.dart';
part 'watch_state.dart';

class WatchCubit extends Cubit<WatchState> {
  WatchCubit()
      : _livestreamsRepo = locator<LivestreamsRepo>(),
        super(const WatchState.initial());

  late final LivestreamsRepo _livestreamsRepo;

  Future<void> getActiveLivestreams() async {
    emit(const WatchState.loading());
    final response = await _livestreamsRepo.getActiveLivestreams();
    response.when(
      success: (data) {
        final baseLiveStream = LiveStream(
          id: '',
          user: UserModel.empty(),
          title: '',
          products: [],
          startTime: DateTime.now(),
          scheduled: false,
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          agoraId: '',
          v: 0,
          isVideo: true,
          videoLink: '',
          thumbnail: '',
        );
        emit(WatchState.success(<LiveStream>[
          baseLiveStream.copyWith(
            videoLink:
                'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514183/Download_3_nrefot.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink:
                'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514183/Download_1_n1e8r1.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink:
                'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514186/Download_4_gobvjs.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink:
                'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514182/Download_2_ateml8.mp4',
          ),
          ...data!.data!
        ]));
      },
      error: (error) {
        emit(
          WatchState.error(error.message ?? 'An error occurred'),
        );
      },
    );
  }
}
