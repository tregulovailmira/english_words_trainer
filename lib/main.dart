import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './injection_container.dart' as di;
import './features/auth/presentation/pages/sign_in.dart';
import './core/pages/splash_page.dart';
import './test_page.dart';
import './features/auth/presentation/pages/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Supabase.initialize(
    url: 'https://apmvfihmxpmpkvrxcarz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwbXZmaWhteHBtcGt2cnhjYXJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTgxMzM5ODksImV4cCI6MTk3MzcwOTk4OX0.OyhgFb1qzPxoVXXjHqUlfjuD3fgNICwTx-AleRDsjyA',
  );
  final client = Supabase.instance.client;
  client.auth.signOut();
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
          '/': (_) => const SplashPage(),
          '/login': (_) => const SignInPage(),
          '/account': (_) => const AccountPage(),
          '/register': (_) => const SignUpPage(),
        });
    // home: const SignInPage());
  }
}
