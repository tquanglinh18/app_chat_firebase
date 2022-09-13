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
          ?.map((e) => DocumentEntity.fromJson(e as Map<String, dynamic>))
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

DocumentEntity _$DocumentEntityFromJson(Map<String, dynamic> json) =>
    DocumentEntity(
      path: json['path'] as String?,
      type: json['type'] as String?,
      pathThumbnail: json['pathThumbnail'] as String?,
      name: json['name'] as String?,
      isHeader: json['isHeader'] as bool? ?? false,
      nameSend: json['nameSend'] as String?,
      createAt: json['createAt'] as String?,
    );

Map<String, dynamic> _$DocumentEntityToJson(DocumentEntity instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
      'pathThumbnail': instance.pathThumbnail,
      'name': instance.name,
      'isHeader': instance.isHeader,
      'nameSend': instance.nameSend,
      'createAt': instance.createAt,
    };
