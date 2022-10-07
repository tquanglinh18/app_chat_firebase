// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryEntity _$StoryEntityFromJson(Map<String, dynamic> json) => StoryEntity(
      listStory: (json['listStory'] as List<dynamic>?)
          ?.map((e) => StoryItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$StoryEntityToJson(StoryEntity instance) =>
    <String, dynamic>{
      'listStory': instance.listStory,
      'name': instance.name,
      'uid': instance.uid,
    };

StoryItemEntity _$StoryItemEntityFromJson(Map<String, dynamic> json) =>
    StoryItemEntity(
      createdAt: json['createdAt'] as String?,
      urlImage: json['urlImage'] as String?,
    );

Map<String, dynamic> _$StoryItemEntityToJson(StoryItemEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'urlImage': instance.urlImage,
    };
