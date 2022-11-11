import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './core/pages/splash_page.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/auth/presentation/pages/sign_in.dart';
import './features/auth/presentation/pages/sign_up.dart';
import './features/dictionary/presentation/pages/dictionary_page.dart';
import './features/profile/presentation/bloc/profile_bloc.dart';
import './features/profile/presentation/pages/profile.dart';
import './features/vocabulary/presentation/bloc/quiz/quiz_bloc.dart';
import './features/vocabulary/presentation/bloc/words_list_bloc.dart';
import './features/vocabulary/presentation/pages/from_english_mode_trainer.dart';
import './features/vocabulary/presentation/pages/my_vocabulary.dart';
import './features/vocabulary/presentation/pages/quiz_page.dart';
import './features/vocabulary/presentation/pages/trainer.dart';
import './injection_container.dart' as di;
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.init();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['ANON_KEY'],
  );
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WordsListBloc>(
      create: (blocContext) => di.sl<WordsListBloc>(),
      child: MaterialApp(
        title: 'English words trainer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.green.shade800,
            secondary: Colors.green.shade600,
          ),
          textTheme:
              const TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          Routes.splashPage: (_) => const SplashPage(),
          Routes.signInPage: (_) => const SignInPage(),
          Routes.profile: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProfileBloc>(
                    create: (BuildContext context) => di.sl<ProfileBloc>(),
                  ),
                  BlocProvider<AuthBloc>(
                    create: (BuildContext context) => di.sl<AuthBloc>(),
                  ),
                ],
                child: const Profile(),
              ),
          Routes.register: (_) => const SignUpPage(),
          Routes.myVocabulary: (_) => const MyVocabularyPage(),
          Routes.trainer: (_) => const Trainer(),
          Routes.fromEnglishMode: (_) => const FromEnglishModePage(),
          Routes.quiz: (_) => BlocProvider<QuizBloc>(
                create: (context) => di.sl<QuizBloc>(),
                child: const QuizPage(),
              ),
          Routes.dictionary: (_) => const ProviderScope(child: Dictionary()),
        },
      ),
    );
  }
}
