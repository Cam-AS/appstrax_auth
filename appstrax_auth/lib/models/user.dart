import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Model {
  String? id;
  String email;
  String? password;
  Map<String, dynamic> data = {};
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
