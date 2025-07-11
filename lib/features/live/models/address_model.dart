class AddressModel {
  final String fullAddress;
  final String state;
  final String lga;

  AddressModel({
    required this.fullAddress,
    required this.state,
    required this.lga,
  });

  // factory AddressModel.fromGooglePlaceDetails(Map<String, dynamic> json) {
  //   String getComponent(String type) {
  //     return json['address_components']
  //         ?.firstWhere(
  //             (c) => (c['types'] as List).contains(type),
  //         orElse: () => {'long_name': ''})['long_name'] ??
  //         '';
  //   }
  //
  //   return AddressModel(
  //     fullAddress: json['formatted_address'] ?? '',
  //     state: getComponent('administrative_area_level_1'),
  //     lga: getComponent('administrative_area_level_2'),
  //   );
  // }
}
