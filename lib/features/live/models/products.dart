
import 'package:freezed_annotation/freezed_annotation.dart';

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
  });

  factory Product.empty() => Product(
        id: '',
        name: '',
        seller: '',
        category: '',
        price: 0,
        description: '',
        brand: '',
        stockUnit: 0,
        images: [],
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
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  @JsonKey(name: 'seller', defaultValue: '')
  final String seller;
  @JsonKey(name: 'category', defaultValue: '')
  final String category;
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

  @override
  String toString() {
    return '''Product(id: $id, name: $name, seller: $seller, category: $category, price: $price, description: $description, brand: $brand, stockUnit: $stockUnit, images: $images, available: $available, published: $published, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)''';
  }
}
