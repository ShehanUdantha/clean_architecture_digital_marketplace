import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:Pixelcart/src/domain/entities/user/user_entity.dart';

const String userTypeForAll = 'All Account';
const String userTypeForUser = 'User';
const String userTypeForAdmin = 'Admin';

const int userTypeIndexForAll = 0;
const int userTypeIndexForUser = 1;
const int userTypeIndexForAdmin = 2;

const List<UserEntity> allTypeOfUserEntities = [
  UserEntity(
    userId: 'sampleId890',
    userType: 'user',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserEntity(
    userId: 'sampleId231',
    userType: 'admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
  UserEntity(
    userId: 'sampleId9230',
    userType: 'user',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
  UserEntity(
    userId: 'sampleId123',
    userType: 'user',
    userName: 'test user',
    email: 'testUser@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserEntity(
    userId: 'sampleId234',
    userType: 'admin',
    userName: 'test admin',
    email: 'testAdmin@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const List<UserEntity> onlyUserEntities = [
  UserEntity(
    userId: 'sampleId890',
    userType: 'user',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserEntity(
    userId: 'sampleId9230',
    userType: 'user',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
  UserEntity(
    userId: 'sampleId123',
    userType: 'user',
    userName: 'test user',
    email: 'testUser@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const List<UserEntity> onlyAdminEntities = [
  UserEntity(
    userId: 'sampleId231',
    userType: 'admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
  UserEntity(
    userId: 'sampleId234',
    userType: 'admin',
    userName: 'test admin',
    email: 'testAdmin@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const List<UserModel> allTypeOfUserModels = [
  UserModel(
    userId: 'sampleId890',
    userType: 'user',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserModel(
    userId: 'sampleId231',
    userType: 'admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
  UserModel(
    userId: 'sampleId9230',
    userType: 'user',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
  UserModel(
    userId: 'sampleId123',
    userType: 'user',
    userName: 'test user',
    email: 'testUser@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserModel(
    userId: 'sampleId234',
    userType: 'admin',
    userName: 'test admin',
    email: 'testAdmin@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const List<UserModel> onlyUserModels = [
  UserModel(
    userId: 'sampleId890',
    userType: 'user',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserModel(
    userId: 'sampleId9230',
    userType: 'user',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
  UserModel(
    userId: 'sampleId123',
    userType: 'user',
    userName: 'test user',
    email: 'testUser@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const List<UserModel> onlyAdminModels = [
  UserModel(
    userId: 'sampleId231',
    userType: 'admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
  UserModel(
    userId: 'sampleId234',
    userType: 'admin',
    userName: 'test admin',
    email: 'testAdmin@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
];

const UserEntity userUserTypeEntity = UserEntity(
  userId: 'sampleId890',
  userType: 'user',
  userName: 'John Doe',
  email: 'john.doe@example.com',
  password: 'password123',
  deviceToken: 'token123',
);

const UserModel userUserTypeModel = UserModel(
  userId: 'sampleId890',
  userType: 'user',
  userName: 'John Doe',
  email: 'john.doe@example.com',
  password: 'password123',
  deviceToken: 'token123',
);

const userUserTypeJson = {
  'userId': 'sampleId890',
  'userType': 'user',
  'userName': 'John Doe',
  'email': 'john.doe@example.com',
  'password': 'password123',
  'deviceToken': 'token123',
};
