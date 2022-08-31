import 'package:json_annotation/json_annotation.dart';

part 'message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
  @JsonKey()
  String? createdAt;
  @JsonKey()
  String? icConversion;
  @JsonKey()
  String? message;
  @JsonKey()
  String? replyMsg;
  @JsonKey()
  String? type;

  MessageEntity({
    this.createdAt,
    this.icConversion,
    this.message,
    this.replyMsg,
    this.type,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  MessageEntity copyWith({
    String? createdAt,
    String? icConversion,
    String? message,
    String? replyMsg,
    String? type,
  }) {
    return MessageEntity(
      createdAt: createdAt ?? this.createdAt,
      icConversion: icConversion ?? this.icConversion,
      message: message ?? this.message,
      replyMsg: replyMsg ?? this.replyMsg,
      type: type ?? this.type,
    );
  }
}
