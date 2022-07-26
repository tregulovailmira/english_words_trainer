import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './core/components/auth_required_state.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/auth/presentation/widgets/error_message.dart';
import '../../../../injection_container.dart' as di;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends AuthRequiredState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) => di.sl<SignedInUserBloc>(),
      child: const Account(),
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends AuthRequiredState<Account> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile(String userId) async {
    BlocProvider.of<SignedInUserBloc>(context).add(SignedInUser());
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(
        children: <Widget>[
          BlocBuilder<SignedInUserBloc, SignedInUserState>(
              builder: (blocContext, state) {
            if (state is SignedInUserLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ));
            } else if (state is SignedInUserError) {
              return ErrorMessage(state.props[0] as String);
            } else if (state is SignedInUserLoaded) {
              final String? email = state.user?.email;
              _emailController.text = email ?? 'test';
              _phoneController.text = state.user?.phone ?? 'test';
              return Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'User Name'),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    readOnly: true,
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Website'),
                  ),
                  const SizedBox(height: 18),
                ],
              );
            } else {
              return const Center(
                child: Text('test'),
              );
            }
          }),
        ],
      ),
    );
  }
}