// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationEntity _$NotificationEntityFromJson(Map<String, dynamic> json) =>
    NotificationEntity(
      isRead: json['isRead'] as bool? ?? false,
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      message: json['message'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$NotificationEntityToJson(NotificationEntity instance) =>
    <String, dynamic>{
      'isRead': instance.isRead,
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
    };
