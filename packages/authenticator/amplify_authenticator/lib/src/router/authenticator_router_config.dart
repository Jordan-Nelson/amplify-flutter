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
import 'package:flutter/widgets.dart';

/// {@template amplify_authenticator.authenticator_router_config}
/// Amplify Authenticator specific information.
/// {@endtemplate}
class AuthenticatorRouterConfig {
  /// {@macro amplify_authenticator.authenticator_router_config}
  const AuthenticatorRouterConfig({
    required this.onRouteChange,
    this.getReturnToParam,
    this.onSignInLocation = '/',
    this.urlOverrides = const {},
  });

  /// A function that will be invoked when the [AuthenticatorStep] changes,
  /// or when the user authenticates.
  ///
  /// ## Example:
  /// ```dart
  /// (BuildContext context, String url) => GoRouter.of(context).go(url)
  /// ```
  final void Function(BuildContext context, String url) onRouteChange;

  /// A function that returns the current value for the query parameter with the
  /// key `return_to`.
  ///
  /// For example, for a location of "/foo?return_to=/bar", [getReturnToParam]
  /// should return "/bar".
  ///
  /// If provided, this will be used to route the user to the route after
  /// signing in.
  ///
  /// ## Example:
  /// ```dart
  /// (context) {
  ///   final location = GoRouter.of(context).location;
  ///   return Uri.tryParse(location)?.queryParameters['return_to'];
  /// }
  /// ```
  final String? Function(BuildContext context)? getReturnToParam;

  /// The default location the user will be redirected to after sign in if
  /// [getReturnToParam] is not provided.
  final String onSignInLocation;

  /// Overrides of the default URL for each step.
  final Map<AuthenticatorStep, String> urlOverrides;
}
