import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    required String phone,
  }) : super(id: id, email: email, phone: phone);

  factory UserModel.fromUserObject(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      phone: user.phone ?? '',
    );
  }
}
