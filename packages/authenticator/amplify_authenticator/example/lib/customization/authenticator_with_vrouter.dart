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

/// Returns a [VGuard.beforeEnter] hook for routes that require authentication
/// based on the current [BuildContext].
///
/// A redirect will be performed if the user is not authenticated.
Future<void> Function(VRedirector) vRouterAuthRedirect(BuildContext context) {
  return (VRedirector redirector) async {
    final state = AuthenticatorState.of(context);
    final redirectUrl = await state.getRedirectUrl(toUrl: redirector.toUrl);
    if (redirectUrl != null) redirector.to(redirectUrl);
  };
}

/// Returns a [VGuard.beforeEnter] hook for routes that display an
/// [AuthenticatorScreen] widget.
///
/// A redirect will be performed if the user is not eligible for the given step.
Future<void> Function(VRedirector) vRouterRedirectForAuthStep({
  required BuildContext context,
  required AuthenticatorStep step,
}) {
  return (VRedirector redirector) async {
    final state = AuthenticatorState.of(context);
    final redirectUrl = await state.getRedirectUrlForStep(step);
    if (redirectUrl != null) redirector.to(redirectUrl);
  };
}

/// Returns a list of [VRouteElement] widgets, one for each [AuthenticatorStep].
List<VRouteElement> buildAuthenticatorRoutes(BuildContext context) => [
      for (final step in AuthenticatorStep.routerSteps)
        VGuard(
          beforeEnter: vRouterRedirectForAuthStep(context: context, step: step),
          stackedRoutes: [
            VWidget(
              path: step.url,
              transitionDuration: Duration.zero,
              widget: AuthenticatorScreen(step: step),
            ),
          ],
        ),
    ];

/// A [AuthenticatorRouterConfig] using [VRouter] to provide routing behavior.
final authenticatorRouterConfig = AuthenticatorRouterConfig(
  onSignInLocation: '/home',
  onRouteChange: (context, url) => context.vRouter.to(url),

  /// Returns the value of the "return_to" query param. If provided, the
  /// authenticator will track what URL to return to after authentication.
  getReturnToParam: (context) {
    return context.vRouter.queryParameters['return_to'];
  },
);

class AuthenticatorWithVrouter extends StatelessWidget {
  const AuthenticatorWithVrouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticator.router(
      routerInfo: authenticatorRouterConfig,
      // Note: Builder is needed to get the current BuildContext because VRouter
      // does not make this available in redirects.
      child: Builder(
        builder: (context) {
          return VRouter(
            initialUrl: '/home',
            routes: [
              ...buildAuthenticatorRoutes(context),
              VWidget(
                path: '/home',
                widget: const HomeScreen(),
              ),
              VGuard(
                beforeEnter: vRouterAuthRedirect(context),
                stackedRoutes: [
                  VWidget(
                    path: '/profile',
                    widget: const ProfileScreen(),
                  ),
                ],
              ),
            ],
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
                onPressed: () => context.vRouter.to('/home'),
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
