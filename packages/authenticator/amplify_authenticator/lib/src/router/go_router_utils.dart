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

/// {@template amplify_authenticator.go_router_utils.go_router_auth_redirect}
/// Creates a [GoRouterRedirect] that may redirect the user based on their
/// current Authentication state.
///
/// If the user is not authenticated, they will be redirected to the
/// Authenticator. Otherwise, they will not be redirected.
///
/// By default, a `return_to` parameter will be added to the URI to take the
/// user back to the original route after they are authenticated. This can be
/// disabled with [returnTo].
/// {@endtemplate}
GoRouterRedirect goRouterAuthRedirect({bool returnTo = true}) {
  return (
    BuildContext context,
    GoRouterState state,
  ) async {
    final authenticatorState = AuthenticatorState.of(context);
    final isAuthenticated = await authenticatorState.isAuthenticated();
    if (isAuthenticated) {
      return null;
    }
    final params = returnTo ? '?return_to=${state.location}' : null;
    return '${AuthenticatorStep.signIn.url}$params';
  };
}

/// {@template amplify_authenticator.go_router_utils.go_routes}
/// A list of routes for the Authenticator to be used with [GoRouter].
/// {@endtemplate}
// TODO(Jordan-Nelson): Add remaining routes
final goRoutes = [
  GoRoute(
    path: AuthenticatorStep.signIn.url,
    pageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const AuthenticatorScreen.signIn(),
    ),
  ),
  GoRoute(
    path: AuthenticatorStep.signUp.url,
    pageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const AuthenticatorScreen.signUp(),
    ),
  ),
  GoRoute(
    path: AuthenticatorStep.confirmSignUp.url,
    redirect: ((context, state) {
      final authenticatorState = AuthenticatorState.of(context);
      if (authenticatorState.username.isEmpty) {
        return AuthenticatorStep.signUp.url;
      }
      return state.location;
    }),
    pageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const AuthenticatorScreen.confirmSignUp(),
    ),
  ),
  GoRoute(
    path: AuthenticatorStep.resetPassword.url,
    pageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const AuthenticatorScreen.resetPassword(),
    ),
  ),
  GoRoute(
    path: AuthenticatorStep.confirmResetPassword.url,
    pageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const AuthenticatorScreen.confirmResetPassword(),
    ),
  ),
];

/// Creates a [AuthenticatorRouterInfo] object given the required [router] and
/// optional [onSignInLocation].
///
/// If [onSignInLocation] is provided, it will be used as the location to route
/// the user to after sign in.
AuthenticatorRouterInfo buildGoRouterInfo({
  required GoRouter router,
  String? onSignInLocation = '/',
}) {
  return AuthenticatorRouterInfo(
    onStepChange: (BuildContext context, AuthenticatorStep step) {
      final newUrl = _addReturnToParamToUrl(url: step.url, router: router);
      GoRouter.of(context).go(newUrl);
    },
    onSignIn: (BuildContext context) {
      final returnToUrl = _getReturnToUrl(router) ?? onSignInLocation ?? '/';
      return router.go(returnToUrl);
    },
  );
}

/// Gets the `return_to` query param from the URL.
String? _getReturnToUrl(GoRouter router) =>
    Uri.tryParse('https://example.com${router.location}')
        ?.queryParameters['return_to'];

/// Adds the `return_to` query param if the previous route contained it.
String _addReturnToParamToUrl({required String url, required GoRouter router}) {
  final returnToUrl = _getReturnToUrl(router);
  if (returnToUrl != null) {
    return '$url?return_to=$returnToUrl';
  }
  return url;
}

/// {@template amplify_authenticator.go_router_utils.authenticator_step_url}
/// Returns the URL associated with the given step.
/// {@endtemplate}
extension AuthenticatorStepUrl on AuthenticatorStep {
  /// {@macro amplify_authenticator.go_router_utils.authenticator_step_url}
  String get url {
    switch (this) {
      case AuthenticatorStep.signUp:
        return '/sign-up';
      case AuthenticatorStep.signIn:
        return '/sign-in';
      case AuthenticatorStep.confirmSignUp:
        return '/confirm-sign-up';
      case AuthenticatorStep.resetPassword:
        return '/forgot-password';
      case AuthenticatorStep.confirmResetPassword:
        return '/reset-password';
      default:
        // TODO(Jordan-Nelson): Add remaining routes.
        throw StateError('Unhandled step: $this');
    }
  }
}
