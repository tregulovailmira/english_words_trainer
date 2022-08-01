import 'package:english_words_trainer/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.signInPage, (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.myVocabulary, (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
