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

part of authenticator.form_field;

/// {@template authenticator.sign_in_form_field}
/// A form field component on the Sign In screen.
/// {@endtemplate}
abstract class SignInFormField extends AuthenticatorFormField {
  /// {@macro authenticator.sign_in_form_field}
  ///
  /// Either [titleKey] or [title] is required.
  const SignInFormField._({
    Key? key,
    required AuthenticatorFormFieldType field,
    FormFieldValidator<String>? validator,
    bool? required,
    InputResolverKey? titleKey,
    InputResolverKey? hintTextKey,
    String? title,
    String? hintText,
  }) : super._(
          key: key,
          field: field,
          validator: validator,
          required: required,
          titleKey: titleKey,
          hintTextKey: hintTextKey,
          title: title,
          hintText: hintText,
        );

  /// Creates a username component.
  static SignInFormField username({
    Key? key,
    FormFieldValidator<String>? validator,
    bool? required,
  }) =>
      SignInUsernameFormField(
        key: key,
        validator: validator,
        required: required,
      );

  /// Creates a password component.
  static SignInFormField password({
    Key? key,
    FormFieldValidator<String>? validator,
    bool? required,
  }) =>
      SignInPasswordFormField(
        key: key,
        validator: validator,
        required: required,
      );

  @override
  int get displayPriority {
    switch (field) {
      case AuthenticatorFormFieldType.username:
        return 2;
      case AuthenticatorFormFieldType.password:
        return 1;
      default:
        throw StateError('$field is not supported as a sign in field');
    }
  }
}

class SignInPasswordFormField extends SignInFormField {
  const SignInPasswordFormField({
    Key? key,
    FormFieldValidator<String>? validator,
    bool? required,
  }) : super._(
          key: key,
          field: AuthenticatorFormFieldType.password,
          titleKey: InputResolverKey.passwordTitle,
          hintTextKey: InputResolverKey.passwordHint,
          validator: validator,
          required: required,
        );

  @override
  _SignInPasswordFormFieldState createState() =>
      _SignInPasswordFormFieldState();
}

class _SignInPasswordFormFieldState extends AuthenticatorFormFieldState
    with AuthenticatorTextFormFieldMixin {}

class SignInUsernameFormField extends SignInFormField {
  const SignInUsernameFormField({
    Key? key,
    FormFieldValidator<String>? validator,
    bool? required,
  }) : super._(
          key: key,
          field: AuthenticatorFormFieldType.username,
          titleKey: InputResolverKey.usernameTitle,
          hintTextKey: InputResolverKey.usernameHint,
          validator: validator,
          required: required,
        );

  @override
  _SignInUsernameFormFieldState createState() =>
      _SignInUsernameFormFieldState();
}

class _SignInUsernameFormFieldState extends AuthenticatorFormFieldState
    with AuthenticatorUsernameFormFieldMixin {}

// TODO: Move AuthenticatorTextFormFieldMixin to it's own file
mixin AuthenticatorTextFormFieldMixin on AuthenticatorFormFieldState {
  @override
  ValueChanged<String> get onChanged {
    switch (widget.field) {
      case AuthenticatorFormFieldType.username:
        return viewModel.setUsername;
      case AuthenticatorFormFieldType.verificationCode:
        return viewModel.setConfirmationCode;
      case AuthenticatorFormFieldType.password:
        return viewModel.setPassword;
      case AuthenticatorFormFieldType.newPassword:
        return viewModel.setNewPassword;
      case AuthenticatorFormFieldType.passwordConfirmation:
        return viewModel.setPasswordConfirmation;
      case AuthenticatorFormFieldType.address:
        return viewModel.setAddress;
      case AuthenticatorFormFieldType.email:
        return (String input) {
          if (selectedUsernameType == UsernameType.email) {
            viewModel.setUsername(input);
          }
          viewModel.setEmail(input);
        };
      case AuthenticatorFormFieldType.familyName:
        return viewModel.setFamilyName;
      case AuthenticatorFormFieldType.gender:
        return viewModel.setGender;
      case AuthenticatorFormFieldType.givenName:
        return viewModel.setGivenName;
      case AuthenticatorFormFieldType.middleName:
        return viewModel.setMiddleName;
      case AuthenticatorFormFieldType.name:
        return viewModel.setName;
      case AuthenticatorFormFieldType.nickname:
        return viewModel.setNickname;
      case AuthenticatorFormFieldType.preferredUsername:
        return viewModel.setPreferredUsername;
      case AuthenticatorFormFieldType.custom:
        // TODO: handle custom attributes
        return viewModel.setPreferredUsername;
      // return (String value) => viewModel.setCustom(
      //       widget._customAttributeKey!,
      //       value,
      //     );
      case AuthenticatorFormFieldType.confirmVerify:
        return viewModel.setPreferredUsername;
      default:
        throw StateError(
            '${widget.field} is not supported as a AuthenticatorTextFormField}');
    }
  }

  @override
  Widget buildFormField(BuildContext context) {
    final inputResolver = stringResolver.inputs;
    final hintText = widget.hintText == null
        ? widget.hintTextKey?.resolve(context, inputResolver)
        : widget.hintText!;
    return ValueListenableBuilder<bool>(
      valueListenable: context
          .findAncestorStateOfType<AuthenticatorFormState>()!
          .obscureTextToggleValue,
      builder: (BuildContext context, bool toggleObscureText, Widget? _) {
        var obscureText = this.obscureText && toggleObscureText;
        return TextFormField(
          style: enabled
              ? null
              : TextStyle(color: AmplifyTheme.of(context).fontDisabled),
          initialValue: initialValue,
          enabled: enabled,
          validator: widget.validatorOverride ?? validator,
          onChanged: onChanged,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxWidth: 70,
            ),
            suffixIcon: suffix,
            errorMaxLines: errorMaxLines,
            hintText: hintText,
            isDense: true,
          ),
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
        );
      },
    );
  }
}

// TODO: Move AuthenticatorUsernameFormFieldMixin to it's own file
mixin AuthenticatorUsernameFormFieldMixin on AuthenticatorFormFieldState {
  InputResolverKey get titleKey {
    switch (selectedUsernameType) {
      case UsernameType.username:
        return InputResolverKey.usernameTitle;
      case UsernameType.email:
        return InputResolverKey.emailTitle;
      case UsernameType.phoneNumber:
        return InputResolverKey.phoneNumberTitle;
    }
  }

  @override
  Widget get title {
    final inputResolver = stringResolver.inputs;
    final titleString = inputResolver.resolve(context, titleKey);
    final labelText = Text(
      isOptional ? inputResolver.optional(context, titleString) : titleString,
    );
    // Mirrors internal impl. to create an "always active" Switch theme.
    final thumbColor = Theme.of(context).toggleableActiveColor;
    final trackColor = thumbColor.withOpacity(0.5);

    switch (usernameType) {
      case UsernameConfigType.username:
      case UsernameConfigType.email:
      case UsernameConfigType.phoneNumber:
        return labelText;
      case UsernameConfigType.emailOrPhoneNumber:
      default:
        return SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              labelText,
              IconTheme.merge(
                data: const IconThemeData(size: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone),
                    Switch(
                      thumbColor: MaterialStateProperty.all(thumbColor),
                      trackColor: MaterialStateProperty.all(trackColor),
                      value: useEmail.value,
                      onChanged: (val) {
                        setState(() {
                          useEmail.value = val;
                        });

                        // Reset current username value to align with the current switch state.
                        String newUsername = val
                            ? viewModel.getAttribute(
                                    CognitoUserAttributeKey.email) ??
                                ''
                            : viewModel.getAttribute(
                                    CognitoUserAttributeKey.phoneNumber) ??
                                '';
                        viewModel.setUsername(newUsername);
                      },
                    ),
                    const Icon(Icons.email),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget buildFormField(BuildContext context) {
    switch (selectedUsernameType) {
      case UsernameType.username:
        return AuthenticatorTextFormField._usernameNoLabel(
          required: widget.required,
          key: widget.key,
          validator: widget.validatorOverride,
        );
      case UsernameType.email:
        return AuthenticatorTextFormField._emailNoLabel(
          required: widget.required,
          key: widget.key,
          validator: widget.validatorOverride,
        );
      case UsernameType.phoneNumber:
        return AuthenticatorPhoneFormField._phoneNumberNoLabel(
          required: widget.required,
          key: widget.key,
          validator: widget.validatorOverride,
        );
    }
  }
}
