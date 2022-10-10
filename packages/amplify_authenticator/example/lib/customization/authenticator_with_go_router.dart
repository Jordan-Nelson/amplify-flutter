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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// A custom authenticator widget that uses Go Router.
class AuthenticatorWithGoRouter extends StatelessWidget {
  AuthenticatorWithGoRouter({Key? key}) : super(key: key);

  final _router = AuthenticatorGoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        redirect: AuthenticatorGoRouter.authRedirect(),
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      routerInfo: _router.routerInfo,
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
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
                  GoRouter.of(context).go('/profile');
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
                  GoRouter.of(context).go('/');
                },
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 32),
              SignOutButton(
                onSignOut: (() => GoRouter.of(context).go('/sign-in')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
