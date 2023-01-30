import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/screens/screen_statistics.dart';
import 'package:go_router/go_router.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {


  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: ScreenMain.routeLocation,
    routes: [
      GoRoute(
        path: ScreenMain.routeLocation,
        name: ScreenMain.routeName,
        builder: (context, state) {
          return const ScreenMain();
        },
      ),
      GoRoute(
        path: ScreenStatistics.routeLocation,
        name: ScreenStatistics.routeName,
        builder: (context, state) {
          return const ScreenStatistics();
        },
      ),

      // taken from https://firebase.google.com/codelabs/firebase-get-to-know-flutter#4
      GoRoute(
        path: "/sign-in",
        name: "sign-in",
        builder: (context, state) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) {
                Navigator.of(context)
                    .pushNamed('/forgot-password', arguments: {'email': email});
              })),
              AuthStateChangeAction(((context, state) {
                if (state is SignedIn || state is UserCreated) {
                  var user = (state is SignedIn)
                      ? state.user
                      : (state as UserCreated).credential.user;
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.go(ScreenMain.routeLocation);
                }
              })),
            ],
          );
        },
      ),


      GoRoute(
        path: "/forgot-password",
        name: "forgot-password",
        builder: (context, state) {
          final arguments = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'] as String,
            headerMaxExtent: 200,
          );
        },
      ),


      GoRoute(
        path: "/profile",
        name: "profile",
        builder: (context, state) {return ProfileScreen(
          providers: const [],
          //children: [ TextButton(onPressed: onPressedBack, child: Text("back"))],
          actions: [
            SignedOutAction(
              ((context) {
                context.go(ScreenMain.routeLocation);
              }),
            ),
          ],
        );
        },
      ),



    ],
    redirect: (context, state) {
      ScreenMain.routeLocation;
      return null;
    },
  );
});


