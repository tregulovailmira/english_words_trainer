import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/animated_logo.dart';
import '../../../../injection_container.dart' as di;
import '../../../../routes.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/redirect_button.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => di.sl<AuthBloc>(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AnimatedLogo(
                text: 'Welcome',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Login to EW trainer',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
              const SignInForm(),
              const SizedBox(height: 15),
              const RedirectButton(
                Routes.register,
                'Not registered yet? Sign Up',
              )
            ],
          ),
        ),
      ),
    );
  }
}
