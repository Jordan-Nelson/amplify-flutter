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

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' hide AuthState;
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_authenticator/src/blocs/auth/auth_bloc.dart';
import 'package:amplify_authenticator/src/blocs/auth/auth_data.dart';
import 'package:amplify_authenticator/src/state/auth_state.dart';
import 'package:amplify_authenticator/src/state/inherited_authenticator_state.dart';
import 'package:amplify_authenticator/src/utils/country_code.dart';
import 'package:amplify_authenticator/src/widgets/form.dart';
import 'package:flutter/material.dart';

@visibleForTesting
typedef BlocEventPredicate = bool Function(AuthState state);

/// State of the Amplify Authenticator.
///
/// Contains the form data for the Authenticator (username, password, etc.) as
/// well as methods to sign the user in or transition to a new Authentication State.
///
/// Intended to be used within custom UIs for the Amplify Authenticator.
class AuthenticatorState extends ChangeNotifier {
  AuthenticatorState(this._authBloc, this._routerInfo) {
    // Listen to step changes to know when to clear the form. Calling `clean`
    // from the forms' dispose method is unreliable since it may be called after
    // the transitioning form's first build is called.
    //
    // When auth flow is complete, reset entirety of the view model state.
    _authBloc.stream.distinct().listen((event) {
      resetCode();
      if (event is AuthenticatedState) {
        _handleSignInRouteChange(event, _routerInfo);
        _resetAttributes();
      }
    });

    // Always listen for ConfirmSignInCustom events (not distinct)
    _authBloc.stream.listen((event) {
      if (event is ConfirmSignInCustom) {
        publicChallengeParams = event.publicParameters;
      }
    });
  }

  void _handleSignInRouteChange(
    AuthenticatedState event,
    AuthenticatorRouterConfig? config,
  ) {
    final context = event.context;
    final initialRoute = event.initialRoute;
    if (initialRoute || context == null || config == null) return;
    final getReturnToParam = config.getReturnToParam ?? (_) => null;
    final url = getReturnToParam(context) ?? config.onSignInLocation;
    config.onRouteChange(context, url);
  }

  final StateMachineBloc _authBloc;

  final AuthenticatorRouterConfig? _routerInfo;

  /// The current step of the authentication flow (signIn, signUp, confirmSignUp, etc.)
  AuthenticatorStep get currentStep {
    AuthState state = _authBloc.currentState;
    if (state is LoadingState) {
      return AuthenticatorStep.loading;
    } else if (state is UnauthenticatedState) {
      return state.step;
    } else {
      return AuthenticatorStep.signIn;
    }
  }

  Future<bool> isAuthenticated() async {
    final state = await _authBloc.stream.firstWhere(
      (state) => (state is! LoadingState),
    );
    if (state is UnauthenticatedState) {
      return false;
    }
    return true;
  }

  /// A utility for building route guards for [AuthenticatorScreen] Widgets.
  ///
  /// {@template amplify_authenticator.authenticator_state.redirect_url_for_step}
  /// If the user is not eligible for the [step] provided, this will return a
  /// url that they should be redirected to.
  ///
  /// If the user is currently authenticated, this will be
  /// [AuthenticatorRouterConfig.onSignInLocation].
  /// {@endtemplate}
  Future<String?> getRedirectUrlForStep(AuthenticatorStep step) async {
    final isAuthenticated = await this.isAuthenticated();
    if (isAuthenticated) return _routerInfo?.onSignInLocation ?? '/';
    switch (step) {
      // Allow direct links (deep links) to signUp, signIn, and resetPassword.
      case AuthenticatorStep.signUp:
      case AuthenticatorStep.signIn:
      case AuthenticatorStep.resetPassword:
        return null;

      /// Only allow navigating to other steps if the step being navigated to
      /// matches the current step.
      default:
        return step == currentStep ? AuthenticatorStep.signIn.url : null;
    }
  }

  /// A utility for building route guards for routes that should require
  /// authentication.
  ///
  /// {@template amplify_authenticator.authenticator_state.redirect_url}
  /// If the current user is unauthenticated, returns a url that the user should
  /// be redirected to.
  ///
  /// For example, if an unauthenticated user tries to route to a [toUrl] of
  /// '/settings', the return value will be '/sign-in?return_to=/settings'.
  ///
  /// [returnTo] can be set to false if the return to url should not be
  /// tracked. In this case, the user will be redirected to the default route
  /// after authenticating.
  /// {@endtemplate}
  Future<String?> getRedirectUrl({
    required String? toUrl,
    bool returnTo = true,
  }) async {
    final isAuthenticated = await this.isAuthenticated();
    if (isAuthenticated) return null;
    final params = returnTo && toUrl != null ? '?return_to=$toUrl' : null;
    return '${AuthenticatorStep.signIn.url}$params';
  }

  // TODO(Jordan-Nelson): Investigate bug with `listen: true`.
  // This was causing an issue with go_router when navigating directly to a
  // route with a guard while authenticated.
  static AuthenticatorState of(BuildContext context) =>
      InheritedAuthenticatorState.of(context, listen: false);

  /// Indicates if the form is currently in a loading state
  ///
  /// Will be set to true when an asynchronous action (such as login) in
  /// initiated, and will be set to false when that asynchronous action completes
  bool get isBusy => _isBusy;

  bool _isBusy = false;
  void _setIsBusy(bool busy) {
    _isBusy = busy;
    notifyListeners();
  }

  /// The value for the username form field
  ///
  /// This value will be used during sign up, sign in, or other actions
  /// that required the username
  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  String _username = '';

  /// {@macro amplify_authenticator.username_input.username_selection}
  ///
  /// Defaults to [UsernameSelection.email].
  ///
  /// The value has no meaning for Auth configurations that do not allow
  /// for email OR phone number to be used as username.
  UsernameSelection get usernameSelection => _usernameSelection;

  set usernameSelection(UsernameSelection value) {
    _usernameSelection = value;
    notifyListeners();
  }

  UsernameSelection _usernameSelection = UsernameSelection.email;

  /// The value for the password form field
  ///
  /// This value will be used during sign up, sign in, or other actions
  /// that required the password
  String get password => _password;

  set password(String value) {
    _password = value.trim();
    notifyListeners();
  }

  String _password = '';

  /// The value for the password confirmation form field
  ///
  /// This value will be used during sign up, or other actions
  /// that required the password confirmation
  String get passwordConfirmation => _passwordConfirmation;

  set passwordConfirmation(String value) {
    _passwordConfirmation = value;
    notifyListeners();
  }

  String _passwordConfirmation = '';

  String get confirmationCode => _confirmationCode;

  /// The value for the confirmation code form field
  ///
  /// This value will be used during confirm sign up, or other actions
  /// that required the confirmation code
  set confirmationCode(String value) {
    _confirmationCode = value;
    notifyListeners();
  }

  String _confirmationCode = '';

  /// The publicChallengeParameters received from the CreateAuthChallenge lambda during custom auth
  ///
  /// This value will be used during the custom auth challenge flow
  set publicChallengeParams(Map<String, String> value) {
    _publicChallengeParams = value;
    notifyListeners();
  }

  Map<String, String> get publicChallengeParams => _publicChallengeParams;

  /// Public setter not needed, as _publicChallengeParams will only be set in current scope
  Map<String, String> _publicChallengeParams = <String, String>{};

  /// The value for the new password form field
  ///
  /// This value will be used during reset password, or other actions
  /// that required the password
  String get newPassword => _newPassword;

  set newPassword(String value) {
    _newPassword = value.trim();
    notifyListeners();
  }

  String _newPassword = '';

  /// The value for the country code portion of the phone number field
  Country get country => _country;

  set country(Country newCountry) {
    final oldCountry = _country;
    final currentPhoneNumber =
        authAttributes[CognitoUserAttributeKey.phoneNumber];
    if (currentPhoneNumber != null) {
      authAttributes[CognitoUserAttributeKey.phoneNumber] =
          currentPhoneNumber.replaceFirst(
        oldCountry.value,
        newCountry.value,
      );
    }
    _country = newCountry;
    notifyListeners();
  }

  Country _country = countryCodes.first;

  final Map<CognitoUserAttributeKey, String> authAttributes = {};

  // Returns the form field value for a User Attribute
  String? getAttribute(CognitoUserAttributeKey key) => authAttributes[key];

  void _setAttribute(CognitoUserAttributeKey attribute, String value) {
    authAttributes[attribute] = value.trim();
    notifyListeners();
  }

  set address(String address) {
    _setAttribute(CognitoUserAttributeKey.address, address);
  }

  set birthdate(String birthdate) {
    _setAttribute(CognitoUserAttributeKey.birthdate, birthdate);
  }

  set email(String email) {
    _setAttribute(CognitoUserAttributeKey.email, email);
  }

  set familyName(String familyName) {
    _setAttribute(CognitoUserAttributeKey.familyName, familyName);
  }

  set gender(String gender) {
    _setAttribute(CognitoUserAttributeKey.gender, gender);
  }

  set givenName(String givenName) {
    _setAttribute(CognitoUserAttributeKey.givenName, givenName);
  }

  set locale(String locale) {
    _setAttribute(CognitoUserAttributeKey.locale, locale);
  }

  set middleName(String middleName) {
    _setAttribute(CognitoUserAttributeKey.middleName, middleName);
  }

  set name(String name) {
    _setAttribute(CognitoUserAttributeKey.name, name);
  }

  set nickname(String nickname) {
    _setAttribute(CognitoUserAttributeKey.nickname, nickname);
  }

  set phoneNumber(String phoneNumber) {
    _setAttribute(CognitoUserAttributeKey.phoneNumber, phoneNumber);
  }

  set picture(String picture) {
    _setAttribute(CognitoUserAttributeKey.picture, picture);
  }

  set preferredUsername(String preferredUsername) {
    _setAttribute(
      CognitoUserAttributeKey.preferredUsername,
      preferredUsername,
    );
  }

  set profile(String profile) {
    _setAttribute(CognitoUserAttributeKey.profile, profile);
  }

  set zoneInfo(String zoneInfo) {
    _setAttribute(CognitoUserAttributeKey.zoneinfo, zoneInfo);
  }

  set updatedAt(String updatedAt) {
    _setAttribute(CognitoUserAttributeKey.updatedAt, updatedAt);
  }

  set website(String website) {
    _setAttribute(CognitoUserAttributeKey.website, website);
  }

  void setCustomAttribute(CognitoUserAttributeKey key, String value) {
    _setAttribute(key, value);
  }

  bool _rememberDevice = false;
  bool get rememberDevice => _rememberDevice;
  set rememberDevice(bool value) {
    _rememberDevice = value;
    notifyListeners();
  }

  CognitoUserAttributeKey _attributeKeyToVerify = CognitoUserAttributeKey.email;
  CognitoUserAttributeKey get attributeKeyToVerify => _attributeKeyToVerify;

  set attributeKeyToVerify(CognitoUserAttributeKey attributeKey) {
    _attributeKeyToVerify = attributeKey;
    notifyListeners();
  }

  /// Complete custom auth form using the values for [confirmationCode],
  /// [rememberDevice], and any user attributes.
  Future<void> confirmSignInCustomAuth(BuildContext context) async {
    if (!confirmSignInCustomAuthFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmSignInData(
      confirmationValue: _confirmationCode.trim(),
      attributes: authAttributes,
      rememberDevice: rememberDevice,
      context: context,
    );
    _authBloc.add(AuthConfirmSignIn(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Complete MFA using the values for [confirmationCode],
  /// [rememberDevice], and any user attributes.
  Future<void> confirmSignInMFA(BuildContext context) async {
    if (!confirmSignInMFAFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmSignInData(
      confirmationValue: _confirmationCode.trim(),
      attributes: authAttributes,
      rememberDevice: rememberDevice,
      context: context,
    );
    _authBloc.add(AuthConfirmSignIn(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Complete the force password change with [newPassword]
  Future<void> confirmSignInNewPassword(BuildContext context) async {
    if (!confirmSignInNewPasswordFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmSignInData(
      confirmationValue: _newPassword.trim(),
      attributes: authAttributes,
      rememberDevice: rememberDevice,
      context: context,
    );
    _authBloc.add(AuthConfirmSignIn(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Confirm sign up with [confirmationCode], [username], and [password]
  Future<void> confirmSignUp(BuildContext context) async {
    if (!confirmSignUpFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmSignUpData(
      code: _confirmationCode.trim(),
      username: _username.trim(),
      password: _password.trim(),
      context: context,
    );
    _authBloc.add(AuthConfirmSignUp(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Sign in with [username], and [password]
  Future<void> signIn(BuildContext context) async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthUsernamePasswordSignInData(
      username: _username.trim(),
      password: _password.trim(),
      context: context,
    );
    _authBloc.add(AuthSignIn(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Perform social sign in with the given provider
  Future<void> signInWithProvider(
    AuthProvider provider,
    BuildContext context,
  ) async {
    final data = AuthSocialSignInData(
      provider: provider,
      context: context,
    );
    _authBloc.add(AuthSignIn(data));
  }

  /// Sign out the current user
  Future<void> signOut(BuildContext context) async {
    _setIsBusy(true);
    _authBloc.add(AuthSignOut(AuthSignOutData(context: context)));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Initiates the reset password process for the user with the given [username]
  Future<void> resetPassword(BuildContext context) async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthResetPasswordData(
      username: _username.trim(),
      context: context,
    );
    _authBloc.add(AuthResetPassword(data));
    await nextBlocEvent(
      where: (state) => state is UnauthenticatedState,
    );
    _setIsBusy(false);
  }

  /// Completes the reset password process with [confirmationCode],
  /// [username], and [newPassword]
  Future<void> confirmResetPassword(BuildContext context) async {
    if (!confirmResetPasswordFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmResetPasswordData(
      username: _username.trim(),
      confirmationCode: _confirmationCode.trim(),
      newPassword: _newPassword.trim(),
      context: context,
    );
    _authBloc.add(AuthConfirmResetPassword(data));
    await nextBlocEvent(
      where: (state) => state is UnauthenticatedState,
    );
    _setIsBusy(false);
  }

  /// Sign up with [username], [password] and any user attributes
  Future<void> signUp(BuildContext context) async {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthSignUpData(
      username: _username.trim(),
      password: _password.trim(),
      attributes: authAttributes,
      context: context,
    );
    _authBloc.add(AuthSignUp(data));
    await nextBlocEvent();
    _setIsBusy(false);
  }

  /// Resend sign up code for the user with the given [username]
  Future<void> resendSignUpCode(BuildContext context) async {
    final data = AuthResendSignUpCodeData(
      username: _username.trim(),
      context: context,
    );
    _authBloc.add(AuthResendSignUpCode(data));
    await nextBlocEvent();
  }

  Future<void> confirmVerifyUser(
    CognitoUserAttributeKey userAttributeKey,
    BuildContext context,
  ) async {
    if (!confirmVerifyUserFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthConfirmVerifyUserData(
      userAttributeKey: userAttributeKey,
      code: _confirmationCode,
      context: context,
    );
    _authBloc.add(AuthConfirmVerifyUser(data));
    await nextBlocEvent(
      where: (state) =>
          state is UnauthenticatedState || state is AuthenticatedState,
    );
    _setIsBusy(false);
  }

  Future<void> verifyUser(BuildContext context) async {
    if (!verifyUserFormKey.currentState!.validate()) {
      return;
    }
    _setIsBusy(true);
    final data = AuthVerifyUserData(
      userAttributeKey: attributeKeyToVerify,
      context: context,
    );
    _authBloc.add(AuthVerifyUser(data));
    await nextBlocEvent(
      where: (state) => state is! LoadingState,
    );
    _setIsBusy(false);
  }

  void skipVerifyUser(BuildContext context) {
    final data = AuthSkipVerifyUserData(context: context);
    _authBloc.add(AuthSkipVerifyUser(data));
  }

  @visibleForTesting
  Future<void> nextBlocEvent({BlocEventPredicate? where}) async {
    await Future.any([
      _authBloc.exceptions.first,

      // Bloc emits current state first
      _authBloc.stream
          .skip(1)
          .firstWhere((state) => where?.call(state) ?? true),
    ]);
  }

  /// Change to a new step in the authentication flow.
  ///
  /// If [reset] is `true`, clears temporary form data including username,
  /// password, and user attributes.
  void changeStep(
    AuthenticatorStep step, {
    required BuildContext context,
    bool reset = true,
  }) {
    if (_routerInfo != null) {
      final fullUrl = _addReturnToParamToUrl(
        url: step.url,
        config: _routerInfo!,
        context: context,
      );
      _routerInfo!.onRouteChange(context, fullUrl);
    }
    final data = AuthChangeScreenData(context: context, step: step);
    _authBloc.add(AuthChangeScreen(data));

    /// Clean [ViewModel] when user manually navigates widgets
    if (reset) {
      _resetAttributes();
    }
  }

  /// Gets the `return_to` query param from the URL.
  // String? _getReturnToUrl(
  //   AuthenticatorRouterConfig config,
  //   BuildContext context,
  // ) {
  //   if (config.getLocation == null) {
  //     return null;
  //   }
  //   final fullUrl = config.getLocation!(context);
  //   return Uri.tryParse('https://example.com${fullUrl}')
  //       ?.queryParameters['return_to'];
  // }

  /// Adds the `return_to` query param if the previous route contained it.
  String _addReturnToParamToUrl({
    required String url,
    required AuthenticatorRouterConfig config,
    required BuildContext context,
  }) {
    final getReturnToParam = config.getReturnToParam ?? (_) => null;
    final returnToUrl = getReturnToParam(context);
    if (returnToUrl != null) {
      return '$url?return_to=$returnToUrl';
    }
    return url;
  }

  /// Reset the authentication flow if initiated
  void abortSignIn(BuildContext context) {
    _resetAttributes();
    final data = AuthSignOutData(context: context);
    _authBloc.add(AuthSignOut(data));
  }

  void _resetAttributes() {
    _username = '';
    _password = '';
    _passwordConfirmation = '';
    _confirmationCode = '';
    _newPassword = '';
    authAttributes.clear();
    _publicChallengeParams.clear();
  }

  void resetCode() {
    _confirmationCode = '';
  }
}
