/*
 * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

/// The current step of the authentication flow.
enum AuthenticatorStep {
  /// The authenticator is in a loading state.
  ///
  /// Either Amplify.configure() or the current authentication status
  /// is pending.
  loading(),

  /// The user is on the Onboarding step.
  ///
  /// This step can be used to create an onboarding view that will be
  /// displayed to users prior to showing sign in / sign up.
  ///
  /// See Onboarding guidelines from Material and Human Interface Guidelines
  /// - Material: https://material.io/design/communication/onboarding.html
  /// - Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/ios/app-architecture/onboarding/
  ///
  /// This step is only relevant if a custom builder is provided to the
  /// Authenticator. The prebuilt authenticator takes users directly to
  /// sign in by default.
  onboarding(url: '/onboarding'),

  /// The user is on the Sign Up step.
  signUp(url: '/sign-up'),

  /// The user is on the Sign In step.
  signIn(url: '/sign-in'),

  /// The user is on the Confirm Sign Up step.
  ///
  /// The user has signed up, but their account is currently in
  /// an unconfirmed state.
  confirmSignUp(url: '/confirm-sign-up'),

  /// The user is on the Confirm Sign In (Custom Auth) step.
  ///
  /// The user has performed the initial step of the sign in process,
  /// and should be presented with a form to enter a response to a custom auth challenge.
  confirmSignInCustomAuth(url: '/confirm-sign-in-custom-challenge'),

  /// The user is on the Confirm Sign In with MFA (Multi-factor
  /// Authentication) step.
  ///
  /// The user has performed the initial step of the sign in process,
  /// and should be presented with a form to enter their confirmation code.
  confirmSignInMfa(url: '/confirm-sign-in-mfa'),

  /// The user is on the Confirm Sign In with New Password step.
  ///
  /// The user has performed the initial step of the sign in process,
  /// and is required to change their password in order to complete
  /// the sign in process.
  confirmSignInNewPassword(url: '/confirm-sign-in-new-password'),

  /// The user is on the Reset Password step.
  resetPassword(url: '/reset-password'),

  /// The user is on the Confirm Reset Password step.
  confirmResetPassword(url: '/confirm-reset-password'),

  /// The user is on the Verify User step.
  ///
  /// The user has successfully signed in and their account is confirmed,
  /// however they do not have any means of account recovery (email, phone)
  /// that is confirmed.
  verifyUser(url: '/verify-account'),

  /// The user is on the Confirm Verify User step.
  ///
  /// The user has initiated verification of an account recovery means
  /// (email, phone), and needs to provide a verification code.
  confirmVerifyUser(url: '/confirm-verify-account');

  const AuthenticatorStep({this.url});

  /// The url used for this step.
  final String? url;

  /// [AuthenticatorStep]s that should have a route defined when using the
  /// Router API.
  static Iterable<AuthenticatorStep> get routerSteps =>
      values.where((step) => step.url != null);
}

const validInitialAuthenticatorSteps = [
  AuthenticatorStep.onboarding,
  AuthenticatorStep.signIn,
  AuthenticatorStep.signUp,
  AuthenticatorStep.resetPassword,
];
