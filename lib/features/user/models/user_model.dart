import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonEnum()
enum UserType {
  @JsonValue('buyer')
  buyer,
  @JsonValue('seller')
  seller,
}

@JsonSerializable(createToJson: false)
class UserModel {
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.email,
    required this.userType,
    required this.active,
    required this.phoneVerified,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.businessProfile,
  });

  factory UserModel.withId(String id) => UserModel(
        id: id,
        firstName: '',
        lastName: '',
        username: '',
        phone: '',
        email: '',
        userType: UserType.buyer,
        active: false,
        phoneVerified: false,
        emailVerified: false,
        createdAt: '',
        updatedAt: '',
        v: 0,
        businessProfile: BusinessProfile.empty(),
      );

  factory UserModel.empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        phone: '',
        email: '',
        userType: UserType.buyer,
        active: false,
        phoneVerified: false,
        emailVerified: false,
        createdAt: '',
        updatedAt: '',
        v: 0,
        businessProfile: BusinessProfile.empty(),
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  @JsonKey(name: 'firstName', defaultValue: '')
  final String firstName;
  @JsonKey(name: 'lastName', defaultValue: '')
  final String lastName;
  @JsonKey(name: 'username', defaultValue: '')
  final String username;
  @JsonKey(name: 'phone', defaultValue: '')
  final String phone;
  @JsonKey(name: 'email', defaultValue: '')
  final String email;
  @JsonKey(name: 'userType', defaultValue: UserType.buyer)
  final UserType userType;
  @JsonKey(name: 'active', defaultValue: false)
  final bool active;
  @JsonKey(name: 'phoneVerified', defaultValue: false)
  final bool phoneVerified;
  @JsonKey(name: 'emailVerified', defaultValue: false)
  final bool emailVerified;
  @JsonKey(name: 'createdAt', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'updatedAt', defaultValue: '')
  final String updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int v;
  @JsonKey(name: 'businessProfile', defaultValue: BusinessProfile.empty)
  final BusinessProfile businessProfile;

  @override
  String toString() {
    return '''UserModel(id: $id, firstName: $firstName, lastName: $lastName, username: $username, phone: $phone, email: $email, userType: $userType, active: $active, phoneVerified: $phoneVerified, emailVerified: $emailVerified, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, )''';
  }
}

@JsonSerializable(createToJson: false)
class BusinessProfile {
  BusinessProfile({
    required this.id,
    required this.user,
    required this.businessName,
    required this.registered,
    required this.identification,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BusinessProfile.empty() => BusinessProfile(
        id: '',
        user: '',
        businessName: '',
        registered: false,
        identification: Identification.empty(),
        createdAt: '',
        updatedAt: '',
        v: 0,
      );

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);

  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  @JsonKey(name: 'user', defaultValue: '')
  final String user;
  @JsonKey(name: 'businessName', defaultValue: '')
  final String businessName;
  @JsonKey(name: 'registered', defaultValue: false)
  final bool registered;
  @JsonKey(name: 'identification', defaultValue: Identification.empty)
  final Identification identification;
  @JsonKey(name: 'createdAt', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'updatedAt', defaultValue: '')
  final String updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int v;

  @override
  String toString() {
    return '''BusinessProfile(id: $id, user: $user, businessName: $businessName, registered: $registered, identification: $identification, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)''';
  }
}

@JsonSerializable(createToJson: false)
class Identification {
  Identification({
    required this.type,
    required this.verified,
    required this.image,
  });

  factory Identification.empty() => Identification(
        type: '',
        verified: false,
        image: '',
      );

  factory Identification.fromJson(Map<String, dynamic> json) =>
      _$IdentificationFromJson(json);

  @JsonKey(name: 'type', defaultValue: '')
  final String type;
  @JsonKey(name: 'verified', defaultValue: false)
  final bool verified;
  @JsonKey(name: 'image', defaultValue: '')
  final String image;

  @override
  String toString() {
    return 'Identification(type: $type, verified: $verified, image: $image)';
  }
}
