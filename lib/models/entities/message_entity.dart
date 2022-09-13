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
  List<DocumentEntity>? document;
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
    List<DocumentEntity>? document,
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
class DocumentEntity {
  @JsonKey()
  String? path;
  @JsonKey()
  String? type;
  @JsonKey()
  String? pathThumbnail;
  @JsonKey()
  String? name;
  @JsonKey()
  bool isHeader;
  @JsonKey()
  String? nameSend;
  @JsonKey()
  String? createAt;

  DocumentEntity(
      {this.path, this.type, this.pathThumbnail, this.name, this.isHeader = false, this.nameSend, this.createAt});

  factory DocumentEntity.fromJson(Map<String, dynamic> json) => _$DocumentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentEntityToJson(this);

  DocumentEntity copyWith({
    String? path,
    String? type,
    String? pathThumbnail,
    String? name,
    bool? isHeader,
    String? nameSend,
    String? createAt,
  }) {
    return DocumentEntity(
      path: path ?? this.path,
      type: type ?? this.type,
      pathThumbnail: pathThumbnail ?? this.pathThumbnail,
      name: name ?? this.name,
      isHeader: isHeader ?? this.isHeader,
      nameSend: nameSend ?? this.nameSend,
      createAt: createAt ?? this.createAt,
    );
  }
}
