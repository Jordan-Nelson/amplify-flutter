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

part of 'auth_bloc.dart';

abstract class AuthEvent<T extends AuthData> {
  const AuthEvent(this.data);
  final T data;
}

class AuthLoad extends AuthEvent<AuthLoadData> {
  const AuthLoad(super.data);
}

class AuthChangeScreen extends AuthEvent<AuthChangeScreenData> {
  const AuthChangeScreen(super.data);
}

class AuthSignIn extends AuthEvent<AuthSignInData> {
  const AuthSignIn(super.data);
}

class AuthSignUp extends AuthEvent<AuthSignUpData> {
  const AuthSignUp(super.data);
}

class AuthConfirmSignUp extends AuthEvent<AuthConfirmSignUpData> {
  const AuthConfirmSignUp(super.data);
}

class AuthSignOut extends AuthEvent<AuthSignOutData> {
  const AuthSignOut(super.data);
}

class AuthExceptionEvent extends AuthEvent<AuthData> {
  const AuthExceptionEvent(super.data);
}

class AuthResetPassword extends AuthEvent<AuthResetPasswordData> {
  const AuthResetPassword(super.data);
}

class AuthConfirmResetPassword extends AuthEvent<AuthConfirmResetPasswordData> {
  const AuthConfirmResetPassword(super.data);
}

class AuthUpdatePassword extends AuthEvent<AuthUpdatePasswordData> {
  const AuthUpdatePassword(super.data);
}

class AuthConfirmSignIn extends AuthEvent<AuthConfirmSignInData> {
  const AuthConfirmSignIn(super.data);
}

class AuthSetUnverifiedAttributeKeys
    extends AuthEvent<AuthSetUnverifiedAttributeKeysData> {
  const AuthSetUnverifiedAttributeKeys(super.data);
}

class AuthVerifyUser extends AuthEvent<AuthVerifyUserData> {
  const AuthVerifyUser(super.data);
}

class AuthSkipVerifyUser extends AuthEvent<AuthSkipVerifyUserData> {
  const AuthSkipVerifyUser(super.data);
}

class AuthConfirmVerifyUser extends AuthEvent<AuthConfirmVerifyUserData> {
  const AuthConfirmVerifyUser(super.data);
}

class AuthResendSignUpCode extends AuthEvent<AuthResendSignUpCodeData> {
  const AuthResendSignUpCode(super.data);
}
