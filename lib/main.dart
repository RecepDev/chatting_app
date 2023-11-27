import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/model/user_database_provider.dart';
import 'package:chatting_app/screens/-home_page.dart';
import 'package:chatting_app/screens/auth.dart';
import 'package:chatting_app/screens/splash.dart';
import 'package:chatting_app/screens/verify_email.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  initializeDateFormatting();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();

  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  await userDatabaseProvider.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(
    App(navigatorKey: navigatorKey),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.navigatorKey,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider(
      create: (context) => CallerIdNotifier(),
      child: MaterialApp(
        routes: {
          '/home': (_) =>
              const HomePage(), // You can also use MaterialApp's `home` property instead of '/'
          // No way to pass an argument to FooPage.
        },
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              if (snapshot.hasData) {
                return const VerifyEmailpage();
              }
              return const AuthScreen();
            }),
      ),
    );
  }
}
