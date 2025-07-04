part of 'wallet_cubit.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.loaded(WalletModel data) = _Loaded;
  const factory WalletState.error(String error) = _Error;
}
