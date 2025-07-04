import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';

part 'wallet_model.g.dart';

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    required String userId,
    required int balance,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  factory WalletModel.empty() => WalletModel(
        id: '',
        userId: '',
        balance: 0,
        currency: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}
