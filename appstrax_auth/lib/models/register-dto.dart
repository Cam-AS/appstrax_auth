import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'register-dto.g.dart';

@JsonSerializable()
class RegisterDto extends Model {
  String email;
  String password;
  Map data;

  RegisterDto({
    required this.email,
    required this.password,
    required this.data,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) => _$RegisterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}
