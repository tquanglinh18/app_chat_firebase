// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      createdAt: json['createdAt'] as String?,
      icConversion: json['icConversion'] as String?,
      message: json['message'] as String?,
      replyMsg: json['replyMsg'] as String?,
      type: json['type'] as String?,
      document: (json['document'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      nameSend: json['nameSend'] as String?,
      nameReply: json['nameReply'] as String?,
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'icConversion': instance.icConversion,
      'message': instance.message,
      'replyMsg': instance.replyMsg,
      'type': instance.type,
      'document': instance.document,
      'nameSend': instance.nameSend,
      'nameReply': instance.nameReply,
    };

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      path: json['path'] as String?,
      type: json['type'] as String?,
      pathThumbnail: json['pathThumbnail'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
      'pathThumbnail': instance.pathThumbnail,
      'name': instance.name,
    };
