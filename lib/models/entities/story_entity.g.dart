// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryEntity _$StoryEntityFromJson(Map<String, dynamic> json) => StoryEntity(
      listImagePath: (json['listImagePath'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$StoryEntityToJson(StoryEntity instance) =>
    <String, dynamic>{
      'listImagePath': instance.listImagePath,
      'name': instance.name,
      'uid': instance.uid,
    };
