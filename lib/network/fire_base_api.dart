import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base/models/entities/message_entity.dart';

class FirebaseApi {

  static Future<bool> uploadMessage(
      String idUser, List<MessageEntity> listMessage) async {
    bool isCheck = false;
    final refMessages =
        FirebaseFirestore.instance.collection('user').doc(idUser);
    await refMessages.update({
      'messages': listMessage.map((e) => e.toJson()).toList(),
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

  static Future<List<MessageEntity>> getMessages(String idUser) async {
    try {
      List<MessageEntity> list = [];
      await FirebaseFirestore.instance.collection("user").get().then((event) {
        for (var doc in event.docs) {
          if (doc.id == idUser) {
            if (doc.data()['messages'] != null) {
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

}
