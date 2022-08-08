import 'package:flutter/material.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes.dart';
import '../widgets/mode_button.dart';

class Trainer extends StatefulWidget {
  const Trainer({Key? key}) : super(key: key);

  @override
  TrainerState createState() => TrainerState();
}

class TrainerState extends AuthRequiredState<Trainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Trainer',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select mode',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const NavigateModeButton(
              buttonText: 'From English to Russian',
              route: Routes.fromEnglishMode,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
