import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:Pixelcart/src/domain/entities/user/user_entity.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_in_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_up_params.dart';

const SignInParams userSignInParams = SignInParams(
  email: 'testUser@example.com',
  password: 'password123',
);

const SignUpParams userSignUpParams = SignUpParams(
  userName: 'testUser',
  email: 'testUser@example.com',
  password: 'password123',
);

const userUserId = 'sampleId123';
const userUserType = 'user';
const userUserEmail = 'testUser@example.com';

const userAdminId = 'sampleId234';
const userAdminType = 'admin';
const userAdminEmail = 'testAdmin@example.com';

const UserEntity userUserEntity = UserEntity(
  userId: 'sampleId123',
  userType: 'user',
  userName: 'test user',
  email: 'testUser@example.com',
  password: 'password123',
  deviceToken: 'token123',
);

const UserModel userUserModel = UserModel(
  userId: 'sampleId123',
  userType: 'user',
  userName: 'test user',
  email: 'testUser@example.com',
  password: 'password123',
  deviceToken: 'token123',
);

const UserEntity userAdminEntity = UserEntity(
  userId: 'sampleId234',
  userType: 'admin',
  userName: 'test admin',
  email: 'testAdmin@example.com',
  password: 'password123',
  deviceToken: 'token123',
);

const UserModel userAdminModel = UserModel(
  userId: 'sampleId234',
  userType: 'admin',
  userName: 'test admin',
  email: 'testAdmin@example.com',
  password: 'password123',
  deviceToken: 'token123',
);
