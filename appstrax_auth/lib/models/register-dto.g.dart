// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) {
  return RegisterDto(
    email: json['email'] as String,
    password: json['password'] as String,
    data: json['data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'data': instance.data,
    };
