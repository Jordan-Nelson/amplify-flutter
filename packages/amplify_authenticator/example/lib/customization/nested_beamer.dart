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

class NestedBeamer extends StatelessWidget {
  NestedBeamer({Key? key}) : super(key: key);

  static final beamerParser = BeamerParser(onParse: (info) {
    print(info);
    return info;
  });

  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const HomeScreen(),
        '/profile': (context, state, data) {
          return const ProfileScreen();
        },
        '/auth/:foo': (context, state, data) {
          return AuthenticatorRouter();
        },
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BeamerProvider(
      routerDelegate: routerDelegate,
      child: Authenticator.withRouter(
        routerInfo: AuthenticatorRouterInfo(
          onSignIn: (BuildContext context) {
            return Beamer.of(context).beamToNamed('/');
          },
          onStepChange: (context, step) {
            return Beamer.of(context).beamToNamed(step.url);
          },
        ),
        child: Builder(builder: (context) {
          return MaterialApp.router(
            routerDelegate: routerDelegate,
            routeInformationParser: beamerParser,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
          );
        }),
      ),
    );
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/auth/sign-in');
                },
                child: const Text('Go to Sign In'),
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
              SignOutButton(
                onSignOut: (() =>
                    Beamer.of(context).beamToNamed('/auth/sign-in')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
