import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/models/variant_model.dart';
import 'package:popcart/features/user/models/user_model.dart';

part 'products.g.dart';

@JsonSerializable(createToJson: false)
class Product {
  Product({
    required this.id,
    required this.name,
    required this.seller,
    required this.category,
    required this.price,
    required this.description,
    required this.brand,
    required this.stockUnit,
    required this.images,
    required this.available,
    required this.published,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.productVariants,
  });

  factory Product.empty() => Product(
        id: '',
        name: '',
        seller: UserModel.empty(),
        category: ProductCategory.init(),
        price: 0,
        description: '',
        brand: '',
        stockUnit: 0,
        images: [],
        productVariants: [],
        available: false,
        published: false,
        createdAt: '',
        updatedAt: '',
        v: 0,
      );

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  final String name;
  @SellerConverter()
  @JsonKey(name: 'seller', defaultValue: UserModel.empty)
  final UserModel seller;
  @CategoryConverter()
  @JsonKey(
    name: 'category',
  )
  final ProductCategory category;
  @JsonKey(name: 'price', defaultValue: 0)
  final double price;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  @JsonKey(name: 'brand', defaultValue: '')
  final String brand;
  @JsonKey(name: 'stockUnit', defaultValue: 0)
  final int stockUnit;
  @JsonKey(name: 'images', defaultValue: [])
  final List<String> images;
  @JsonKey(name: 'available', defaultValue: false)
  final bool available;
  @JsonKey(name: 'published', defaultValue: false)
  final bool published;
  @JsonKey(name: 'createdAt', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'updatedAt', defaultValue: '')
  final String updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int v;
  @JsonKey(name: 'variants', defaultValue: [])
  final List<VariantModel> productVariants;

  @override
  String toString() {
    return '''Product(id: $id, name: $name, seller: $seller, category: $category, price: $price, description: $description, brand: $brand, stockUnit: $stockUnit, images: $images, available: $available, published: $published, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)''';
  }
}

class SellerConverter implements JsonConverter<UserModel, dynamic> {
  const SellerConverter();

  @override
  UserModel fromJson(dynamic json) {
    // If it's a string (just the ID)
    if (json is String) {
      return UserModel.withId(json);
    }
    // If it's a Map/object with seller details
    else if (json is Map<String, dynamic>) {
      return UserModel.fromJson(json);
    }
    // Default case
    return UserModel.empty();
  }

  @override
  dynamic toJson(UserModel seller) {
    // Since you're using createToJson: false, this isn't strictly necessary
    return seller.id;
  }
}

@JsonSerializable(createToJson: false)
class LiveStream {
  LiveStream({
    required this.id,
    required this.user,
    required this.title,
    required this.products,
    required this.startTime,
    required this.scheduled,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.agoraId,
  });

  factory LiveStream.empty() => LiveStream(
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
      );

  factory LiveStream.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamFromJson(json);
  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  @JsonKey(name: 'user', defaultValue: UserModel.empty)
  final UserModel user;
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'products', defaultValue: [])
  final List<String> products;
  @JsonKey(name: 'startTime', defaultValue: null)
  final DateTime? startTime;
  @JsonKey(name: 'scheduled', defaultValue: false)
  final bool scheduled;
  @JsonKey(name: 'active', defaultValue: true)
  final bool active;
  @JsonKey(name: 'createdAt', defaultValue: DateTime.now)
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt', defaultValue: DateTime.now)
  final DateTime updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int v;
  @JsonKey(name: 'agoraId', defaultValue: '')
  final String agoraId;

  @override
  String toString() {
    return '''LiveStream(id: $id, user: $user, title: $title, products: $products, startTime: $startTime, scheduled: $scheduled, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, agoraId: $agoraId)''';
  }
}

@JsonSerializable(createToJson: false)
class Stream {
  Stream({
    required this.id,
    required this.user,
    required this.title,
    required this.products,
    required this.startTime,
    required this.scheduled,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.agoraId,
  });

  factory Stream.empty() => Stream(
        id: '',
        user: '',
        title: '',
        products: [],
        startTime: null,
        scheduled: false,
        active: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        agoraId: '',
        v: 0,
      );

  factory Stream.fromJson(Map<String, dynamic> json) => _$StreamFromJson(json);
  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  @JsonKey(name: 'user', defaultValue: '')
  final String user;
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'products', defaultValue: [])
  final List<String> products;
  @JsonKey(name: 'startTime', defaultValue: null)
  final String? startTime;
  @JsonKey(name: 'scheduled', defaultValue: false)
  final bool scheduled;
  @JsonKey(name: 'active', defaultValue: true)
  final bool active;
  @JsonKey(name: 'createdAt', defaultValue: DateTime.now)
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt', defaultValue: DateTime.now)
  final DateTime updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int v;
  @JsonKey(name: 'agoraId', defaultValue: '')
  final String agoraId;

  @override
  String toString() {
    return '''Stream(id: $id, user: $user, title: $title, products: $products, startTime: $startTime, scheduled: $scheduled, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, agoraId: $agoraId)''';
  }
}
