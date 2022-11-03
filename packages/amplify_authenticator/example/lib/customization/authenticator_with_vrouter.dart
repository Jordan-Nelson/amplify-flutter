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
import 'package:vrouter/vrouter.dart';

// A custom authenticator widget that uses Go Router.
class AuthenticatorWithVRouter extends StatelessWidget {
  const AuthenticatorWithVRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticator.withRouter(
      // Customer needs to provide `routerInfo` so that the authenticator
      // knows how to handle signIn, and onStepChange
      routerInfo: AuthenticatorRouterInfo(
        onSignIn: (BuildContext context) {
          return context.vRouter.to('/');
        },
        onStepChange: (context, step) {
          switch (step) {
            case AuthenticatorStep.signUp:
              return context.vRouter.to('/sign-up');
            case AuthenticatorStep.signIn:
              return context.vRouter.to('/sign-in');
            case AuthenticatorStep.confirmSignUp:
              return context.vRouter.to('/confirm-sign-up');
            case AuthenticatorStep.resetPassword:
              return context.vRouter.to('/forgot-password');
            case AuthenticatorStep.confirmResetPassword:
              return context.vRouter.to('/confirm-forgot-password');
            default:
              throw StateError('Unhandled step: $step');
          }
        },
      ),
      // Note: Builder is needed to get AuthenticatorState.
      child: Builder(
        builder: (context) {
          final authState = AuthenticatorState.of(context);
          return VRouter(
            routes: [
              VWidget(
                path: '/',
                widget: const HomeScreen(),
              ),
              VGuard(
                // if not authenticated, redirect to sign in
                beforeEnter: (vRedirector) async {
                  final isAuthenticated = await authState.isAuthenticated();
                  if (!isAuthenticated) vRedirector.to('/sign-in');
                },
                stackedRoutes: [
                  VWidget(
                    path: '/profile',
                    widget: const ProfileScreen(),
                  ),
                ],
              ),
              // User needs to define all the routes for the Authenticator, and
              // route guards. They can use Widgets and utils from the
              // Authenticator to make this easier, but it is still a fair
              // amount of configuration.
              VGuard(
                // if already authenticated, redirect to "/"
                beforeEnter: (vRedirector) async {
                  final isAuthenticated = await authState.isAuthenticated();
                  if (isAuthenticated) vRedirector.to('/');
                },
                stackedRoutes: [
                  VWidget(
                    path: '/sign-up',
                    widget: const AuthenticatorScreen.signUp(),
                  ),
                  VWidget(
                    path: '/sign-in',
                    widget: const AuthenticatorScreen.signIn(),
                  ),
                  VWidget(
                    path: '/forgot-password',
                    widget: const AuthenticatorScreen.resetPassword(),
                  ),
                  VGuard(
                    // if AuthenticatorState has no username, redirect to sign-in
                    beforeEnter: (vRedirector) async {
                      if (authState.username.isEmpty) {
                        vRedirector.to('/sign-in');
                      }
                    },
                    stackedRoutes: [
                      VWidget(
                        path: '/confirm-sign-up',
                        widget: const AuthenticatorScreen.confirmSignUp(),
                      ),
                      VWidget(
                        path: '/confirm-forgot-password',
                        widget:
                            const AuthenticatorScreen.confirmResetPassword(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
          );
        },
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
          child: ElevatedButton(
            onPressed: () => context.vRouter.to('/profile'),
            child: const Text('Go to Profile'),
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
                onPressed: () => context.vRouter.to('/'),
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 32),
              SignOutButton(onSignOut: () => context.vRouter.to('/sign-in')),
            ],
          ),
        ),
      ),
    );
  }
}
