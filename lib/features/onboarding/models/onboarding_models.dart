
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/features/onboarding/cubits/cubit/onboarding_cubit.dart';

part 'onboarding_models.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponse {
  RegisterResponse({
    required this.user,
    required this.phoneVerified,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  @JsonKey(defaultValue: User.init)
  final User user;
  @JsonKey(defaultValue: false)
  final bool phoneVerified;
}

@JsonSerializable(createToJson: false)
class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.email,
    required this.userType,
    required this.active,
    required this.phoneVerified,
    required this.emailVerified,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.init() => User(
        firstName: '',
        lastName: '',
        username: '',
        phone: '',
        email: '',
        userType: UserType.buyer,
        active: false,
        phoneVerified: false,
        emailVerified: false,
        id: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @JsonKey(defaultValue: '')
  final String firstName;
  @JsonKey(defaultValue: '')
  final String lastName;
  @JsonKey(defaultValue: '')
  final String username;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: UserType.buyer)
  final UserType userType;
  @JsonKey(defaultValue: false)
  final bool active;
  @JsonKey(defaultValue: false)
  final bool phoneVerified;
  @JsonKey(defaultValue: false)
  final bool emailVerified;
  @JsonKey(defaultValue: '', name: '_id')
  final String id;
  @JsonKey(defaultValue: DateTime.now)
  final DateTime createdAt;
  @JsonKey(defaultValue: DateTime.now)
  final DateTime updatedAt;
}
