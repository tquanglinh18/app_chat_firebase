import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  @JsonKey()
  String? name;
  @JsonKey()
  String? uid;
  @JsonKey()
  String? avatar;

  UserEntity({
    this.name,
    this.uid,
    this.avatar,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  UserEntity copyWith({
    String? name,
    String? uid,
    String? avatar,
  }) {
    return UserEntity(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      avatar: avatar ?? this.avatar,
    );
  }
}
