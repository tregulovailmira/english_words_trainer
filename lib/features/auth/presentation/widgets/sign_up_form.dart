import 'package:english_words_trainer/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/auth_state.dart';
import '../../../../core/utils/validatior.dart';
import '../bloc/auth_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends AuthState<SignUpForm> {
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

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<SignUpBloc>(context).add(SignUpNewUser(
        email: email,
        password: password,
      ));
    }
  }

  void onEmailChanged(value) {
    email = value;
  }

  void onPasswordChanged(value) {
    password = value;
  }

  String? emailValidator(value) => EmailValidator().validate(value!);
  String? passwordValidator(value) => PasswordValidator().validate(value!);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoaded) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/account', (route) => false);
          }
          if (state is SignUpError) {
            context.showErrorSnackBar(message: state.message);
          }
        },
        builder: (context, state) => Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                TextFormField(
                  validator: emailValidator,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  autocorrect: false,
                  onChanged: onEmailChanged,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: passwordValidator,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                      labelText: 'Password'),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: onPasswordChanged,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(150, 55),
                        ),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40))),
                    onPressed: onSubmitForm,
                    child: BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (context, state) {
                      if (state is SignUpLoading) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return const Text('Sign up');
                      }
                    })),
              ],
            )));
  }
}
