// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:amplify_authenticator/src/enums/authenticator_step.dart';
import 'package:amplify_authenticator/src/router/authenticator_router_info.dart';
import 'package:amplify_authenticator/src/screens/authenticator_screen.dart';
import 'package:amplify_authenticator/src/state/authenticator_state.dart';
import 'package:flutter/widgets.dart';

import 'package:go_router/go_router.dart';

/// {@template amplify_authenticator.authenticator_go_router}
/// A [RouterConfig] that extends [GoRouter].
///
/// Used for adding the Authenticator's routes when using the go_router package.
/// {@endtemplate}
class AuthenticatorGoRouter extends GoRouter {
  AuthenticatorGoRouter({
    required List<RouteBase> routes,
    super.errorPageBuilder,
    super.errorBuilder,
    super.redirect,
    super.refreshListenable,
    super.redirectLimit,
    super.routerNeglect,
    super.initialLocation,
    super.observers,
    super.debugLogDiagnostics,
    super.navigatorKey,
    super.restorationScopeId,
  })  : _initialLocation = initialLocation,
        super(routes: _generateRoutes(routes));

  final String? _initialLocation;

  /// Extracts the `return_to` query parameter from the URL.
  String? get _returnToUrl => Uri.tryParse('https://example.com$location')
      ?.queryParameters['return_to'];

  /// A [GoRouterRedirect] that checks the user's current Authentication state.
  ///
  /// If the user is not authenticated, they will be redirected to the
  /// Authenticator.
  ///
  /// By default, a `return_to` parameter will be added to the URI to take the
  /// user back to this route after they authenticated. This can be disabled by
  /// setting `returnTo` to false.
  static GoRouterRedirect authRedirect({bool returnTo = true}) {
    Future<String?> authRedirect(
      BuildContext context,
      GoRouterState state,
    ) async {
      final authenticatorState = AuthenticatorState.of(context);
      final isAuthenticated = await authenticatorState.isAuthenticated();
      if (isAuthenticated) {
        return null;
      }
      if (returnTo) {
        return '/sign-in?return_to=${state.location}';
      }
      return '/sign-in';
    }

    return authRedirect;
  }

  // Takes in
  static List<RouteBase> _generateRoutes(List<RouteBase> routes) {
    return [
      // TODO(Jordan-Nelson): Add remaining routes
      GoRoute(
        path: '/sign-in',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AuthenticatorScreen.signIn(),
        ),
      ),
      GoRoute(
        path: '/sign-up',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AuthenticatorScreen.signUp(),
        ),
      ),
      GoRoute(
        path: '/confirm-account',
        redirect: ((context, state) {
          final authenticatorState = AuthenticatorState.of(context);
          if (authenticatorState.username.isEmpty) {
            return '/sign-up';
          }
          return state.location;
        }),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AuthenticatorScreen.confirmSignUp(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AuthenticatorScreen.resetPassword(),
        ),
      ),
      GoRoute(
        path: '/reset-password',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AuthenticatorScreen.confirmResetPassword(),
        ),
      ),

      ...routes,
    ];
  }

  AuthenticatorRouterInfo get routerInfo {
    return AuthenticatorRouterInfo(
      onStepChange: (BuildContext context, AuthenticatorStep step) {
        /// Adds the `return_to` query param if the previous route contained it.
        String addReturnTo(String url) {
          final returnToUrl = _returnToUrl;
          if (returnToUrl != null) {
            return '$url?return_to=$returnToUrl';
          }
          return url;
        }

        switch (step) {
          case AuthenticatorStep.signUp:
            return GoRouter.of(context).go(addReturnTo('/sign-up'));
          case AuthenticatorStep.signIn:
            return GoRouter.of(context).go(addReturnTo('/sign-in'));
          case AuthenticatorStep.confirmSignUp:
            return GoRouter.of(context).go(addReturnTo('/confirm-sign-up'));
          case AuthenticatorStep.resetPassword:
            return GoRouter.of(context).go(addReturnTo('/forgot-password'));
          case AuthenticatorStep.confirmResetPassword:
            return GoRouter.of(context).go(addReturnTo('/reset-password'));
          default:
            throw StateError('Unhandled step: $step');
        }
      },
      onSignIn: (BuildContext context) {
        final returnToUrl = _returnToUrl ?? _initialLocation ?? '/';
        return go(returnToUrl);
      },
    );
  }
}
