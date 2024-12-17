class PaginationResponse<T> {
  PaginationResponse();
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginationResponse<T>()
      ..count = json['count'] as num
      ..next = json['next'] as String
      ..previous = json['previous'] as String
      ..results =
          (json['results'] as List<Object?>).map((e) => fromJsonT(e)).toList();
  }
  late num count;
  late String next;
  late String previous;
  late List<T> results;

  @override
  String toString() {
    return '''PaginationModel<$T>(count: $count, next: $next, previous: $previous, results: $results)''';
  }
}
