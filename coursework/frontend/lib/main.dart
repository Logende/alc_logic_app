import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/router.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:frontend/screens/screen_error.dart';
import 'package:frontend/screens/screen_loading.dart';
import 'package:frontend/screens/screen_main.dart';

import 'firebase_options.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

//  This is a FutureProvider that will be used to check whether the firebase has been initialized or not

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsFlutterBinding.ensureInitialized();

    final router = ref.watch(routerProvider);
    final gameState = ref.watch(gameStateProvider);
    final initializeFirebase = ref.watch(firebaseInitializerProvider);

    return initializeFirebase.when(
        data: (data) {
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            title: 'ALC Logic App',
            theme: gameState.darkMode
                ? createDarkTheme(context)
                : createLightTheme(context),
          );
        },
        loading: () => const LoadingScreen(),
        error: (e, stackTrace) => ErrorScreen(e, stackTrace));

  }

  // light Theme
  ThemeData createLightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
        primaryColor: Color(0xFFffbd45),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFFffbd45), secondary: Color(0xFFb2fab4)));
  }

// dark Theme
  ThemeData createDarkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
        primaryColor: Color(0xFFc25e00),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFFc25e00), secondary: Color(0xFF519657)));
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      //EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
