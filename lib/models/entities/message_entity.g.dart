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
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'icConversion': instance.icConversion,
      'message': instance.message,
      'replyMsg': instance.replyMsg,
      'type': instance.type,
    };
