// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversionEntity _$ConversionEntityFromJson(Map<String, dynamic> json) =>
    ConversionEntity(
      avatarConversion: json['avatarConversion'] as String?,
      nameConversion: json['nameConversion'] as String?,
      idConversion: json['idConversion'] as String?,
    );

Map<String, dynamic> _$ConversionEntityToJson(ConversionEntity instance) =>
    <String, dynamic>{
      'idConversion': instance.idConversion,
      'avatarConversion': instance.avatarConversion,
      'nameConversion': instance.nameConversion,
    };
