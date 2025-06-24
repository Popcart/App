import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/models/user_model.dart';

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
          videoLink: '', thumbnail: '',
        );
        final liveStreams = <LiveStream>[
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514183/Download_3_nrefot.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514183/Download_1_n1e8r1.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514186/Download_4_gobvjs.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514199/6342220-uhd_2160_3840_24fps_anjn6i.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514202/7667419-uhd_2160_4096_25fps_ociuik.mp4',
          ),
          baseLiveStream.copyWith(
            videoLink: 'https://res.cloudinary.com/dvga8tsyy/video/upload/v1750514182/Download_2_ateml8.mp4',
          ),
          ...?data?.data,
        ];
        emit(ActiveLivestreamsState.success(liveStreams));
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
