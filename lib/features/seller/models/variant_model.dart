class VariantModel {
  VariantModel({
    required this.variant,
    required this.options,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
        variant: json['type'] as String,
        options: List<String>.from(json['options'] as List),
      );

  String variant;
  List<String> options;

  Map<String, dynamic> toJson() {
    return {
      'type': variant,
      'options': options,
    };
  }
}
