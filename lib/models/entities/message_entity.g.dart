// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      createdAt: json['createdAt'] as String?,
      idUser: json['idUser'] as String?,
      message: json['message'] as String?,
      replyMsg: json['replyMsg'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'idUser': instance.idUser,
      'message': instance.message,
      'replyMsg': instance.replyMsg,
      'type': instance.type,
    };
