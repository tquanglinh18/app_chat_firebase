import 'package:json_annotation/json_annotation.dart';

part 'story_entity.g.dart';

@JsonSerializable()
class StoryEntity {
  @JsonKey()
  List<StoryItemEntity>? listStory;
  @JsonKey()
  String? name;
  @JsonKey()
  String? uid;

  StoryEntity({
    this.listStory,
    this.name,
    this.uid,
    ti
  });

  factory StoryEntity.fromJson(Map<String, dynamic> json) => _$StoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoryEntityToJson(this);

  StoryEntity copyWith({
    List<StoryItemEntity>? listStory,
    String? name,
    String? uid,
  }) {
    return StoryEntity(
      listStory: listStory ?? this.listStory,
      name: name ?? this.name,
      uid: uid ?? this.uid,
    );
  }
}

@JsonSerializable()
class StoryItemEntity {
  @JsonKey()
  String? createdAt;
  @JsonKey()
  String? urlImage;


  StoryItemEntity({this.createdAt, this.urlImage});

  factory StoryItemEntity.fromJson(Map<String, dynamic> json) => _$StoryItemEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoryItemEntityToJson(this);

  StoryItemEntity copyWith({
    String? createdAt,
    String? urlImage,
  }) {
    return StoryItemEntity(
      createdAt: createdAt ?? this.createdAt,
      urlImage: urlImage ?? this.urlImage,
    );
  }
}
