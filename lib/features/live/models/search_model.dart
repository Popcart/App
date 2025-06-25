import 'package:json_annotation/json_annotation.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/models/user_model.dart';

part 'search_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchData {

  SearchData({required this.products, required this.sellers});

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);

  final List<Product> products;
  final List<UserModel> sellers;

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}