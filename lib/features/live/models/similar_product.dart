
import 'package:json_annotation/json_annotation.dart';

part 'similar_product.g.dart';

@JsonSerializable()
class SimilarProduct {

  SimilarProduct({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.similarityScore,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) =>
      _$SimilarProductFromJson(json);
  @JsonKey(name: 'product_id')
  final String productId;

  final String name;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'similarity_score')
  final double similarityScore;

  Map<String, dynamic> toJson() => _$SimilarProductToJson(this);
}