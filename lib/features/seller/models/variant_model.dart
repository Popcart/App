class VariantModel {
  String variant;
  List<String> options;

  VariantModel({
    required this.variant,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': variant,
      'options': options,
    };
  }
}
