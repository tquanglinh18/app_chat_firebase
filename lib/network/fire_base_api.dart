import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_base/models/entities/chat_user_entity.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/entities/story_entity.dart';
import 'package:flutter_base/models/entities/user_entity.dart';

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
        'story': story.map((e) => e.toJson()).toList(),
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

  static Future<bool> addConversion(Map<String, dynamic> value) async {
    bool isCheck = false;
    try {
      await FirebaseFirestore.instance.collection('user').add(value).then((value) {
        isCheck = true;
      });
      return isCheck;
    } catch (e) {
      return isCheck;
    }
  }

  static Future<String> urlImage(String filePath) async {
    String downloadUrl = '';
    try {
//       final storageRef = FirebaseStorage.instance.ref();
//
// // Create a reference to "mountains.jpg"
//       final mountainsRef = storageRef.child(filePath);
//
//       await mountainsRef.putFile(File(filePath)).then((downloadUrl) async {
//         await mountainsRef.getDownloadURL().then((urlDL) {
//           print("$urlDL");
//         });
//       }, onError: () {
//         print("onError");
//       });
      final file = File(filePath);

// Create the file metadata
      final metadata = SettableMetadata(contentType: filePath.split("/").last);

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef.child(filePath).putFile(file, metadata);

// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
      return downloadUrl;
    } catch (e) {
      return downloadUrl;
    }
  }
}
