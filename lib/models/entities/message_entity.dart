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
  @JsonKey()
  List<Document>? document;
  @JsonKey()
  String? nameSend;
  @JsonKey()
  String? nameReply;

  MessageEntity({
    this.createdAt,
    this.icConversion,
    this.message,
    this.replyMsg,
    this.type,
    this.document,
    this.nameSend,
    this.nameReply,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  MessageEntity copyWith({
    String? createdAt,
    String? icConversion,
    String? message,
    String? replyMsg,
    String? type,
    String? nameSend,
    String? nameReply,
    List<Document>? document,
  }) {
    return MessageEntity(
      createdAt: createdAt ?? this.createdAt,
      icConversion: icConversion ?? this.icConversion,
      message: message ?? this.message,
      replyMsg: replyMsg ?? this.replyMsg,
      type: type ?? this.type,
      document: document ?? this.document,
      nameSend: nameSend ?? this.nameSend,
      nameReply: nameReply ?? this.nameReply,
    );
  }
}

@JsonSerializable()
class Document {
  @JsonKey()
  String? path;
  @JsonKey()
  String? type;
  @JsonKey()
  String? pathThumbnail;

  Document({
    this.path,
    this.type,
    this.pathThumbnail,
  });

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
