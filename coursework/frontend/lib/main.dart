import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //FirebaseUIAuth.configureProviders([
  //  EmailAuthProvider(),
  //]);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsFlutterBinding.ensureInitialized();

    final router = ref.watch(routerProvider);
    final gameState = ref.watch(gameStateProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'ALC Logic App',
      theme: gameState.darkMode
          ? createDarkTheme(context)
          : createLightTheme(context),
    );
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
