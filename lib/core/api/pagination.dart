class PaginationResponse<T> {
  PaginationResponse();
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    String itemKey,
  ) {
    return PaginationResponse<T>()
      ..page = json['page'] as int
      ..count = json['count'] as int
      ..totalPages = json['totalPages'] as int
      ..results =
          (json[itemKey] as List<Object?>).map((e) => fromJsonT(e)).toList();
  }
  late int page;
  late int totalPages;
  late int count;
  late List<T> results;

  @override
  String toString() {
    return '''PaginationModel<$T>(count: $count,  page: $page, totalPages: $totalPages, results: $results)''';
  }
}
