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
import 'package:amplify_authenticator/src/router/authenticator_router_config.dart';
import 'package:amplify_authenticator/src/screens/authenticator_screen.dart';
import 'package:amplify_authenticator/src/state/authenticator_state.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// A [GoRouterRedirect] for routes that required authentication.
///
/// {@macro amplify_authenticator.authenticator_state.redirect_url}
GoRouterRedirect goRouterAuthRedirect({bool returnTo = true}) {
  return (BuildContext context, GoRouterState state) {
    final authState = AuthenticatorState.of(context);
    return authState.getRedirectUrl(toUrl: state.location, returnTo: returnTo);
  };
}

/// A [GoRouterRedirect] for [AuthenticatorScreen] widgets.
///
/// {@macro amplify_authenticator.authenticator_state.redirect_url_for_step}
GoRouterRedirect goRouterAuthRedirectForStep({
  required AuthenticatorStep step,
}) {
  return (BuildContext context, GoRouterState goRouterState) {
    final authState = AuthenticatorState.of(context);
    return authState.getRedirectUrlForStep(step);
  };
}

/// A list of [GoRoute] objects for each [AuthenticatorStep].
final authenticatorGoRoutes = [
  for (final step in AuthenticatorStep.routerSteps)
    GoRoute(
      path: step.url!,
      redirect: goRouterAuthRedirectForStep(step: step),
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: AuthenticatorScreen(step: step),
      ),
    ),
];

/// Creates a [AuthenticatorRouterConfig] object given the required [router] and
/// optional [onSignInLocation].
///
/// If [onSignInLocation] is provided, it will be used as the location to route
/// the user to after sign in.
AuthenticatorRouterConfig buildGoRouterInfo({
  required GoRouter router,
  String onSignInLocation = '/',
}) {
  return AuthenticatorRouterConfig(
    onRouteChange: (BuildContext context, String url) =>
        GoRouter.of(context).go(url),
    getReturnToParam: (context) {
      final location = GoRouter.of(context).location;
      return Uri.tryParse(location)?.queryParameters['return_to'];
    },
    onSignInLocation: onSignInLocation,
  );
}
