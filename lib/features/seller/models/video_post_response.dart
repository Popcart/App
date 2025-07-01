import 'package:json_annotation/json_annotation.dart';
import 'package:popcart/features/live/models/products.dart';

part 'video_post_response.g.dart';

abstract class FeedItem {}

@JsonSerializable()
class VideoPostData{

  VideoPostData({
    required this.posts,
    required this.page,
    required this.totalPages,
    required this.count,
    this.livestreams = const [],
  });

  factory VideoPostData.fromJson(Map<String, dynamic> json) =>
      _$VideoPostDataFromJson(json);
  final List<VideoPost> posts;
  final List<LiveStream> livestreams;
  final int page;
  final int totalPages;
  final int count;
  Map<String, dynamic> toJson() => _$VideoPostDataToJson(this);
}

@JsonSerializable()
class VideoPost extends FeedItem{

  VideoPost({
    required this.id,
    required this.user,
    required this.caption,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoPost.fromJson(Map<String, dynamic> json) =>
      _$VideoPostFromJson(json);
  @JsonKey(name: '_id')
  final String id;
  final String user;
  final String caption;
  final String video;
  final DateTime createdAt;
  final DateTime updatedAt;
  Map<String, dynamic> toJson() => _$VideoPostToJson(this);
}
