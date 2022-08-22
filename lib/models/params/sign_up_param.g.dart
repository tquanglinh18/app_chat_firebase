// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpParam _$SignUpParamFromJson(Map<String, dynamic> json) => SignUpParam(
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$SignUpParamToJson(SignUpParam instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'phone': instance.phone,
    };
