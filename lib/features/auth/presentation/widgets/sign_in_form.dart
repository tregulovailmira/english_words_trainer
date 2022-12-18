import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/auth_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/validatior.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../../../routes.dart';
import '../bloc/auth_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends AuthState<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInWithEmailAndPasswordEvent(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthUserState>(
      listener: (context, state) {
        if (state is AuthLoaded) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.myVocabulary, (route) => false);
        }
        if (state is AuthError) {
          context.showErrorSnackBar(message: state.message);
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            TextFormField(
              validator: (value) => EmailValidator().validate(value!),
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
              ),
              autocorrect: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) => PasswordValidator().validate(value!),
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
                labelText: 'Password',
              ),
              autocorrect: false,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(150, 55),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 40,
                  ),
                ),
              ),
              onPressed: onSubmitForm,
              child: state is AuthLoading
                  ? const ProgressCircle()
                  : const Text('Sign in'),
            )
          ],
        ),
      ),
    );
  }
}
