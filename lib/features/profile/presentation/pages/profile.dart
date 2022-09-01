import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/profile_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  AuthRequiredState<Profile> createState() => _ProfileState();
}

class _ProfileState extends AuthRequiredState<Profile> {
  String userId = '';

  @override
  void onAuthenticated(Session session) async {
    final user = session.user;
    if (user != null && userId.isEmpty) {
      setState(() {
        userId = user.id;
      });
    }
  }

  void onLogOut() {
    context.read<AuthBloc>().add(SignOutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: ProfileWidget(
        userId: userId,
        onLogOut: onLogOut,
      ),
    );
  }
}
