import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './injection_container.dart' as di;
import './features/auth/presentation/pages/sign_in.dart';
import './core/pages/splash_page.dart';
import './test_page.dart';
import './features/auth/presentation/pages/sign_up.dart';
import './routes.dart';
import './features/vocabulary/presentation/pages/my_vocabulary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
    return MaterialApp(
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
          Routes.account: (_) => const AccountPage(),
          Routes.register: (_) => const SignUpPage(),
          Routes.myVocabulary: (_) => const MyVocabularyPage(),
        });
  }
}
