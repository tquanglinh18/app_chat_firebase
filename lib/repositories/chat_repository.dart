import '../models/entities/chat_user_entity.dart';
import '../models/entities/message_entity.dart';
import '../models/entities/story_entity.dart';
import '../models/entities/user_entity.dart';
import '../network/fire_base_api.dart';

abstract class ChatRepository {
  Future<bool> uploadMessage(String idUser, List<MessageEntity> listMessage);

  Map<String, dynamic> convertMessageEntityToJson(MessageEntity instance);

  Map<String, dynamic> convertDocumentToJson(DocumentEntity instance);

  Future<List<MessageEntity>> getMessages(String idUser);

  Future<List<ConversionEntity>> getConversion();

  Future<bool> uploadProfile(String uid, List<UserEntity> listUser);

  Future<bool> upStory(List<StoryEntity> story);

  Future<List<StoryEntity>> getStory();

  Future<List<UserEntity>> getListUser();

  Future<bool> addConversion(Map<String, dynamic> value);
}

class ChatRepositoryImpl extends ChatRepository {
  @override
  Future<bool> addConversion(Map<String, dynamic> value) async {
    return await FirebaseApi.addConversion(value);
  }

  @override
  Map<String, dynamic> convertDocumentToJson(DocumentEntity instance) {
    return FirebaseApi.convertDocumentToJson(instance);
  }

  @override
  Map<String, dynamic> convertMessageEntityToJson(MessageEntity instance) {
    return FirebaseApi.convertMessageEntityToJson(instance);
  }

  @override
  Future<List<ConversionEntity>> getConversion() {
    return FirebaseApi.getConversion();
  }

  @override
  Future<List<UserEntity>> getListUser() {
    return FirebaseApi.getListUser();
  }

  @override
  Future<List<MessageEntity>> getMessages(String idUser) {
    return FirebaseApi.getMessages(idUser);
  }

  @override
  Future<List<StoryEntity>> getStory() {
    return FirebaseApi.getStory();
  }

  @override
  Future<bool> upStory(List<StoryEntity> story) {
    return FirebaseApi.upStory(story);
  }

  @override
  Future<bool> uploadMessage(String idUser, List<MessageEntity> listMessage) {
    return FirebaseApi.uploadMessage(idUser, listMessage);
  }

  @override
  Future<bool> uploadProfile(String uid, List<UserEntity> listUser) {
    return FirebaseApi.uploadProfile(uid, listUser);
  }
}
