import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_base/models/entities/chat_user_entity.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/entities/story_entity.dart';
import 'package:flutter_base/models/entities/user_entity.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';

class FirebaseApi {
  static Future<bool> uploadMessage(
    String idUser,
    List<MessageEntity> listMessage,
  ) async {
    bool isCheck = false;
    final refMessages = FirebaseFirestore.instance.collection('user').doc(idUser);
    await refMessages.update({
      'messages': listMessage.map((e) => convertMessageEntityToJson(e)).toList(),
    }).then(
      (value) {
        isCheck = true;
      },
      onError: (e) {
        isCheck = false;
      },
    );
    return isCheck;
  }

  static Map<String, dynamic> convertMessageEntityToJson(MessageEntity instance) {
    return {
      'createdAt': instance.createdAt,
      'icConversion': instance.icConversion,
      'message': instance.message,
      'replyMsg': instance.replyMsg,
      'type': instance.type,
      'nameSend': instance.nameSend,
      'nameReply': instance.nameReply,
      'document': (instance.document ?? []).isNotEmpty
          ? instance.document!.map((document) => convertDocumentToJson(document)).toList()
          : [],
    };
  }

  static Map<String, dynamic> convertDocumentToJson(DocumentEntity instance) {
    return {
      'path': instance.path,
      'type': instance.type,
      'pathThumbnail': instance.pathThumbnail,
      'name': instance.name,
      'createAt': instance.createAt,
      'nameSend': instance.nameSend,
      'isHeader': instance.isHeader,
    };
  }

  static Future<List<MessageEntity>> getMessages(String idUser) async {
    try {
      List<MessageEntity> list = [];
      await FirebaseFirestore.instance.collection("user").get().then((event) {
        for (var doc in event.docs) {
          if (doc.id == idUser) {
            if (doc.data()['messages'].length != 0) {
              for (var msg in doc.data()['messages']) {
                list.add(MessageEntity.fromJson(msg));
              }
            }
          }
        }
      });
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<ConversionEntity>> getConversion() async {
    try {
      List<ConversionEntity> listConversion = [];
      await FirebaseFirestore.instance.collection("user").orderBy('createAt', descending: true).get().then(
        (event) {
          if (event.docs.isNotEmpty) {
            for (var doc in event.docs) {
              listConversion.add(
                ConversionEntity(
                  idConversion: doc.id,
                  avatarConversion: doc.data()['avatarConversion'],
                  nameConversion: doc.data()['nameConversion'],
                ),
              );
            }
          }
        },
      );
      return listConversion;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> uploadProfile(String uid, List<UserEntity> listUser) async {
    bool isCheck = false;
    final updateData = FirebaseFirestore.instance.collection('profile').doc('uid');
    await updateData.update(
      {
        'user': listUser.map((e) => e.toJson()).toList(),
      },
    ).then(
      (value) {
        isCheck = true;
      },
      onError: (e) {
        isCheck = false;
      },
    );
    return isCheck;
  }

  static Future<bool> upStory(List<StoryEntity> story) async {
    bool isCheck = false;
    final updateStory = FirebaseFirestore.instance.collection('story').doc('story');
    await updateStory.update(
      {
        'story': story.map((e) => convertStoryEntityToJson(e)).toList(),
      },
    ).then(
      (value) {
        isCheck = true;
      },
      onError: (e) {
        isCheck = false;
      },
    );
    return isCheck;
  }

  static Map<String, dynamic> convertStoryEntityToJson(StoryEntity instance) {
    return {
      'listStory': (instance.listStory ?? []).isNotEmpty
          ? instance.listStory!.map((story) => convertStoryItemToJson(story)).toList()
          : [],
      'name': instance.name,
      'uid': instance.uid,
    };
  }

  static Map<String, dynamic> convertStoryItemToJson(StoryItemEntity instance) {
    return {
      'createdAt': instance.createdAt,
      'urlImage': instance.urlImage,
    };
  }

  static Future<List<StoryEntity>> getStory() async {
    try {
      List<StoryEntity> listStory = [];
      await FirebaseFirestore.instance.collection('story').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            for (var msg in doc.data()['story']) {
              listStory.add(StoryEntity.fromJson(msg));
            }
          }
        }
      });
      return listStory;
    } catch (e) {
      return [];
    }
  }

  static Future<List<UserEntity>> getListUser() async {
    try {
      List<UserEntity> listUser = [];
      await FirebaseFirestore.instance.collection('profile').get().then(
        (event) {
          if (event.docs.isNotEmpty) {
            for (var doc in event.docs) {
              for (var msg in doc.data()['user']) {
                listUser.add(UserEntity.fromJson(msg));
              }
            }
          }
        },
      );
      return listUser;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addConversion(Map<String, dynamic> param) async {
    bool isCheck = false;
    try {
      await FirebaseFirestore.instance.collection('user').add(param).then((value) {
        isCheck = true;
      });
      return isCheck;
    } catch (e) {
      return isCheck;
    }
  }

  static Future<String> uploadDocument(String filePath, TypeDocument type) async {
    String urlLink = '';
    try {
      final firebaseStorage = FirebaseStorage.instance;
      var snapshot = await firebaseStorage
          .ref()
          .child("${type.toTypeDocument}/${filePath.split("/").last}")
          .putFile(File(filePath))
          .whenComplete(() {});
      await snapshot.ref.getDownloadURL().then((value) {
        urlLink = value;
      });
      return urlLink;
    } catch (e) {
      return urlLink;
    }
  }
}
