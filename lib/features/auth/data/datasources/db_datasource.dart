import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class DbDataSource {
  Future<Unit> sighInWithEmailAndPassword(
      {required String email, required String password});

  Future<Unit> sighUp({required String email, required String password});

  Future<UserModel?> getSignedInUser();
}

class DbDataSourceImpl implements DbDataSource {
  final SupabaseClient client;

  DbDataSourceImpl({required this.client});

  @override
  Future<Unit> sighInWithEmailAndPassword(
      {required String email, required String password}) async {
    final response = await client.auth.signIn(email: email, password: password);
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw DataBaseException(response.error!.message, response.statusCode);
    }
  }

  @override
  Future<Unit> sighUp({required String email, required String password}) async {
    final response = await client.auth.signUp(email, password);
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw DataBaseException(response.error!.message, response.statusCode);
    }
  }

  @override
  Future<UserModel?> getSignedInUser() async {
    final user = client.auth.user();
    if (user != null) {
      return UserModel.fromUserObject(user);
    } else {
      return null;
    }
  }
}
