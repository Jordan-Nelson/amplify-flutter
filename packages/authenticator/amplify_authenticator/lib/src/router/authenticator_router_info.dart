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

/// {@template amplify_authenticator.authenticator_router_info}
/// Amplify Authenticator specific information.
/// {@endtemplate}
class AuthenticatorRouterInfo {
  /// {@macro amplify_authenticator.authenticator_router_info}
  const AuthenticatorRouterInfo({
    required this.onSignIn,
    required this.onStepChange,
  });

  /// A function that will be invoked when the [AuthenticatorStep] changes.
  ///
  /// Can be used to integrate the Authenticator with your desired router.
  ///
  /// ### Example:
  /// ```dart
  /// Authenticator(
  ///   TODO: Add Example
  /// );
  /// ```
  final void Function(BuildContext context, AuthenticatorStep step)
      onStepChange;

  /// A method that will be invoked when the user goes from an unauthenticated
  /// state to an authenticated state.
  final void Function(BuildContext context) onSignIn;
}
