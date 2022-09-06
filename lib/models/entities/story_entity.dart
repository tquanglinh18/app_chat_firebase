import 'package:json_annotation/json_annotation.dart';

part 'story_entity.g.dart';

@JsonSerializable()
class StoryEntity {
  @JsonKey()
  List<String>? listImagePath;
  @JsonKey()
  String? name;
  @JsonKey()
  String? uid;

  StoryEntity({
    this.listImagePath,
    this.name,
    this.uid,
  });

  factory StoryEntity.fromJson(Map<String, dynamic> json) => _$StoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoryEntityToJson(this);

  StoryEntity copyWith({
    List<String>? listImagePath,
    String? name,
    String? uid,
  }) {
    return StoryEntity(
      listImagePath: listImagePath ?? this.listImagePath,
      name: name ?? this.name,
      uid: uid ?? this.uid,
    );
  }
}
