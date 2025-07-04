import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/wallet_repo.dart';
import 'package:popcart/features/wallet/model/wallet_model.dart';

part 'wallet_state.dart';

part 'wallet_cubit.freezed.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(const WalletState.initial());
  final WalletRepo _walletRepo = locator<WalletRepo>();

  Future<void> getWalletInfo({
    required String userId,
  }) async {
    emit(const WalletState.loading());
    final response = await _walletRepo.getWalletInfo(userId: userId);
    response.when(
      success: (data) {
        locator<SharedPrefs>().walletBalance = data?.data?.balance ?? 0;
        emit(WalletState.loaded(data?.data ?? WalletModel.empty()));
      },
      error: (error) {
        emit(WalletState.error(error.message ?? 'An error occurred'));
      },
    );
  }
}
