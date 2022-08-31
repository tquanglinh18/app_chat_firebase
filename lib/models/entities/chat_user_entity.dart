import 'package:json_annotation/json_annotation.dart';

part 'chat_user_entity.g.dart';

// @JsonSerializable()
// class ChatUserEntity {
//   @JsonKey()
//   List<UserEntity>? listUser;
//
//   ChatUserEntity({
//     this.listUser,
//   });
//
//   factory ChatUserEntity.fromJson(Map<String, dynamic> json) => _$ChatUserEntityFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ChatUserEntityToJson(this);
// }

@JsonSerializable()
class ConversionEntity {
  @JsonKey()
  String? idConversion;
  @JsonKey()
  String? avatarConversion;
  @JsonKey()
  String? nameConversion;

  ConversionEntity({
    this.avatarConversion,
    this.nameConversion,
    this.idConversion,
  });

  factory ConversionEntity.fromJson(Map<String, dynamic> json) => _$ConversionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionEntityToJson(this);

  ConversionEntity copyWith({
    String? avatarConversion,
    String? nameConversion,
    String? idConversion,
  }) {
    return ConversionEntity(
      avatarConversion: avatarConversion ?? this.avatarConversion,
      nameConversion: nameConversion ?? this.nameConversion,
      idConversion: idConversion ?? this.idConversion,
    );
  }
}
