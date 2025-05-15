import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/features/user/models/user_model.dart';

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

@JsonSerializable(createToJson: false)
class ProductCategory {
  ProductCategory(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.value});

  factory ProductCategory.init() => ProductCategory(
        id: '',
        name: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        value: 0,
      );

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);


  factory ProductCategory.withId(String id) => ProductCategory(
    id: id,
    name: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    value: 0,
  );

  @JsonKey(name: '_id')
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final dynamic value;

  @override
  String toString() {
    return '''ProductCategory(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }
}

class CategoryConverter implements JsonConverter<ProductCategory, dynamic> {
  const CategoryConverter();

  @override
  ProductCategory fromJson(dynamic json) {
    // If it's a string (just the ID)
    if (json is String) {
      return ProductCategory.withId(json);
    }
    // If it's a Map/object with category details
    else if (json is Map<String, dynamic>) {
      return ProductCategory.fromJson(json);
    }
    // Default case
    return ProductCategory.init();
  }

  @override
  dynamic toJson(ProductCategory category) {
    // Since you're using createToJson: false, this isn't strictly necessary
    return category.id;
  }
}

@JsonSerializable(createToJson: false)
class TokenPair {
  TokenPair({
    required this.token,
    required this.refreshToken,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

  @JsonKey(defaultValue: '')
  final String token;
  @JsonKey(defaultValue: '')
  final String refreshToken;

  @override
  String toString() {
    return 'TokenPair(token: $token, refreshToken: $refreshToken)';
  }
}
