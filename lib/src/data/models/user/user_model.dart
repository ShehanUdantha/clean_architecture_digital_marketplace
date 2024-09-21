import '../../../domain/entities/user/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.userType,
    required super.userName,
    required super.email,
    required super.password,
    super.deviceToken,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userType': userType,
        'userName': userName,
        'email': email,
        'password': password,
        'deviceToken': deviceToken,
      };

  factory UserModel.fromEntity(UserEntity userAuthEntity) => UserModel(
        userId: userAuthEntity.userId,
        userType: userAuthEntity.userType,
        userName: userAuthEntity.userName,
        email: userAuthEntity.email,
        password: userAuthEntity.password,
        deviceToken: userAuthEntity.deviceToken,
      );

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map['userId'],
        userType: map['userType'],
        userName: map['userName'],
        email: map['email'],
        password: map['password'],
        deviceToken: map['deviceToken'],
      );

  factory UserModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) =>
      UserModel(
        userId: document['userId'],
        userType: document['userType'],
        userName: document['userName'],
        email: document['email'],
        password: document['password'],
        deviceToken: document.data()?['deviceToken'],
      );
}
