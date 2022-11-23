/*
 * Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';

// A custom authenticator widget that uses Go Router.
class AuthenticatorWithBeamer extends StatelessWidget {
  AuthenticatorWithBeamer({Key? key}) : super(key: key);

  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const HomeScreen(),
        '/profile': (context, state, data) {
          // AuthenticatorGuard is used because Beamer doesn't support async
          // route guards
          return const AuthenticatorGuard(
            child: ProfileScreen(),
          );
        },
        for (final step in AuthenticatorStep.values)
          step.url: (context, state, data) {
            return AuthenticatorScreen(step: step);
          }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Authenticator.router(
      routerInfo: AuthenticatorRouterConfig(
        onSignInLocation: '/profile',
        onRouteChange: (context, url) => Beamer.of(context).beamToNamed(url),
      ),
      child: MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

class AuthenticatorGuard extends StatefulWidget {
  const AuthenticatorGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AuthenticatorGuard> createState() => _AuthenticatorGuardState();
}

class _AuthenticatorGuardState extends State<AuthenticatorGuard> {
  bool _displayChild = false;

  @override
  void didChangeDependencies() {
    AuthenticatorState.of(context).isAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        Beamer.of(context).beamToReplacementNamed('/sign-in');
      } else {
        setState(() => _displayChild = true);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayChild) return widget.child;
    return const Center(child: CircularProgressIndicator());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const Text(
                'This is the default application route and does not require authentication.',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/profile');
                },
                child: const Text('Go to Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const Text('You are logged in.'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/');
                },
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 32),
              const SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
