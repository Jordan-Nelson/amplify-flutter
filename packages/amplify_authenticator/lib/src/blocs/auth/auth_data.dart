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

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

abstract class AuthData {
  const AuthData({required this.context});

  final BuildContext context;
}

class AuthLoadData extends AuthData {
  const AuthLoadData({required super.context});
}

class AuthSignOutData extends AuthData {
  const AuthSignOutData({required super.context});
}

class AuthSkipVerifyUserData extends AuthData {
  const AuthSkipVerifyUserData({required super.context});
}

class AuthChangeScreenData extends AuthData {
  const AuthChangeScreenData({required super.context, required this.step});

  final AuthenticatorStep step;
}

abstract class AuthSignInData extends AuthData {
  const AuthSignInData({required super.context});
}

class AuthUsernamePasswordSignInData extends AuthSignInData {
  const AuthUsernamePasswordSignInData(
      {required this.username, required this.password, required super.context});

  final String username;
  final String password;
}

class AuthSocialSignInData extends AuthSignInData {
  const AuthSocialSignInData({required this.provider, required super.context});

  final AuthProvider provider;
}

///Sign Up Data
class AuthSignUpData extends AuthData {
  const AuthSignUpData({
    required this.password,
    required this.username,
    this.attributes = const {},
    required super.context,
  });

  final Map<CognitoUserAttributeKey, String> attributes;

  final String password;

  final String username;
}

class AuthConfirmSignUpData extends AuthData {
  final String code;

  final String username;

  final String password;

  const AuthConfirmSignUpData({
    required this.username,
    required this.code,
    required this.password,
    required super.context,
  });
}

class AuthResetPasswordData extends AuthData {
  const AuthResetPasswordData({
    required this.username,
    required super.context,
  });

  final String username;
}

class AuthConfirmResetPasswordData extends AuthData {
  const AuthConfirmResetPasswordData({
    required this.username,
    required this.newPassword,
    required this.confirmationCode,
    required super.context,
  });

  final String username;
  final String newPassword;
  final String confirmationCode;
}

class AuthUpdatePasswordData extends AuthData {
  const AuthUpdatePasswordData({
    required this.username,
    required this.newPassword,
    this.attributes = const {},
    required super.context,
  });

  final String username;
  final String newPassword;
  final Map<String, String> attributes;
}

class AuthConfirmSignInData extends AuthData {
  AuthConfirmSignInData({
    required this.confirmationValue,
    required this.rememberDevice,
    this.attributes = const {},
    required super.context,
  });

  final String confirmationValue;
  final Map<CognitoUserAttributeKey, String> attributes;
  final bool rememberDevice;
}

class AuthSetUnverifiedAttributeKeysData extends AuthData {
  const AuthSetUnverifiedAttributeKeysData({
    required this.unverifiedAttributeKeys,
    required super.context,
  });

  final List<String> unverifiedAttributeKeys;
}

class AuthVerifyUserData extends AuthData {
  const AuthVerifyUserData({
    required this.userAttributeKey,
    required super.context,
  });

  final CognitoUserAttributeKey userAttributeKey;
}

class AuthConfirmVerifyUserData extends AuthData {
  const AuthConfirmVerifyUserData({
    required this.userAttributeKey,
    required this.code,
    required super.context,
  });

  final CognitoUserAttributeKey userAttributeKey;
  final String code;
}

class AuthResendSignUpCodeData extends AuthData {
  const AuthResendSignUpCodeData({
    required this.username,
    required super.context,
  });
  final String username;
}
