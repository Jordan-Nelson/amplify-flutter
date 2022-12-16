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

import 'dart:async';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_authenticator/src/blocs/auth/auth_bloc.dart';
import 'package:amplify_authenticator/src/constants/authenticator_constants.dart';
import 'package:amplify_authenticator/src/enums/enums.dart';
import 'package:amplify_authenticator/src/state/auth_state.dart';
import 'package:amplify_authenticator/src/state/inherited_auth_bloc.dart';
import 'package:amplify_authenticator/src/state/inherited_config.dart';
import 'package:amplify_authenticator/src/state/inherited_forms.dart';
import 'package:amplify_authenticator/src/widgets/authenticator_banner.dart';
import 'package:amplify_authenticator/src/widgets/component.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/breakpoint.dart';

class AuthenticatorScreen extends AuthenticatorComponent<AuthenticatorScreen> {
  const AuthenticatorScreen({
    Key? key,
    required this.step,
  }) : super(key: key);

  const AuthenticatorScreen.signUp({Key? key})
      : this(key: key, step: AuthenticatorStep.signUp);

  const AuthenticatorScreen.signIn({Key? key})
      : this(key: key, step: AuthenticatorStep.signIn);

  const AuthenticatorScreen.confirmSignUp({Key? key})
      : this(key: key, step: AuthenticatorStep.confirmSignUp);

  const AuthenticatorScreen.confirmSignInMfa({Key? key})
      : this(key: key, step: AuthenticatorStep.confirmSignInMfa);

  const AuthenticatorScreen.confirmSignInNewPassword({Key? key})
      : this(key: key, step: AuthenticatorStep.confirmSignInNewPassword);

  const AuthenticatorScreen.resetPassword({Key? key})
      : this(key: key, step: AuthenticatorStep.resetPassword);

  const AuthenticatorScreen.confirmResetPassword({Key? key})
      : this(key: key, step: AuthenticatorStep.confirmResetPassword);

  const AuthenticatorScreen.verifyUser({Key? key})
      : this(key: key, step: AuthenticatorStep.verifyUser);

  const AuthenticatorScreen.confirmVerifyUser({Key? key})
      : this(key: key, step: AuthenticatorStep.confirmVerifyUser);

  final AuthenticatorStep step;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AuthenticatorStep>('step', step));
  }

  @override
  AuthenticatorComponentState<AuthenticatorScreen> createState() {
    return _AuthenticatorScreenState();
  }
}

class _AuthenticatorScreenState
    extends AuthenticatorComponentState<AuthenticatorScreen> {
  static final _logger = AmplifyLogger().createChild('Authenticator');

  StateMachineBloc? _stateMachineBloc;
  InheritedConfig? _inheritedConfig;
  late final StreamSubscription<AuthenticatorException> _exceptionSub;
  late final StreamSubscription<MessageResolverKey> _infoSub;
  late final StreamSubscription<AuthState> _successSub;

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void _subscribeToExceptions() {
    _exceptionSub = _stateMachineBloc!.exceptions.listen((exception) {
      var onException = _inheritedConfig!.onException;
      if (onException != null) {
        onException(exception);
      } else {
        _logger.error('Error in AuthBloc', exception);
      }
      if (mounted && exception.showBanner) {
        _showExceptionBanner(
          type: StatusType.error,
          message: exception.message,
        );
      }
    });
  }

  void _subscribeToInfoMessages() {
    final resolver = stringResolver.messages;
    _infoSub = _stateMachineBloc!.infoMessages.listen((key) {
      final context = scaffoldMessengerKey.currentContext;
      if (mounted && context != null) {
        final message = resolver.resolve(context, key);
        _logger.info(message);
        _showExceptionBanner(
          type: StatusType.info,
          message: message,
        );
      } else {
        _logger.info('Could not show banner for key: $key');
      }
    });
  }

  void _showExceptionBanner({
    required StatusType type,
    required String message,
  }) {
    final scaffoldMessengerState = scaffoldMessengerKey.currentState;
    final scaffoldMessengerContext = scaffoldMessengerKey.currentContext;
    if (scaffoldMessengerState == null || scaffoldMessengerContext == null) {
      return;
    }
    var location = _inheritedConfig!.exceptionBannerLocation;
    if (location == ExceptionBannerLocation.none) {
      return;
    }
    if (location == ExceptionBannerLocation.auto) {
      final Size screenSize = MediaQuery.of(scaffoldMessengerContext).size;
      final bool isDesktop =
          screenSize.width > AuthenticatorContainerConstants.smallView;
      location = isDesktop
          ? ExceptionBannerLocation.top
          : ExceptionBannerLocation.bottom;
    }
    if (location == ExceptionBannerLocation.top) {
      scaffoldMessengerState
        ..clearMaterialBanners()
        ..showMaterialBanner(createMaterialBanner(
          scaffoldMessengerContext,
          type: type,
          message: message,
          actionCallback: scaffoldMessengerState.clearMaterialBanners,
        ));
    } else {
      scaffoldMessengerState
        ..clearSnackBars()
        ..showSnackBar(createSnackBar(
          scaffoldMessengerContext,
          type: type,
          message: message,
        ));
    }
  }

  // Clear exception and info banners on successful login.
  void _subscribeToSuccessEvents() {
    _successSub = _stateMachineBloc!.stream.listen((state) {
      if (state is AuthenticatedState) {
        scaffoldMessengerKey.currentState?.removeCurrentMaterialBanner();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stateMachineBloc == null) {
      _stateMachineBloc = InheritedAuthBloc.of(context);
      _inheritedConfig = InheritedConfig.of(context);
      _subscribeToExceptions();
      _subscribeToInfoMessages();
      _subscribeToSuccessEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth;
    final breakpoint = Breakpoint.of(context);
    final isMobile = breakpoint == Breakpoint.small;
    final containerPadding = breakpoint.verticalPadding;

    const signInUpTabs = [AuthenticatorStep.signIn, AuthenticatorStep.signUp];

    Widget child;
    switch (widget.step) {
      case AuthenticatorStep.onboarding:
      case AuthenticatorStep.signIn:
      case AuthenticatorStep.signUp:
        child = AnimatedSize(
          alignment: Alignment.topCenter,
          child: AuthenticatorTabView(
            tabs: signInUpTabs,
            initialIndex: widget.step == AuthenticatorStep.signUp ? 1 : 0,
          ),
          duration: const Duration(milliseconds: 200),
        );
        break;
      case AuthenticatorStep.confirmSignUp:
      case AuthenticatorStep.confirmSignInCustomAuth:
      case AuthenticatorStep.confirmSignInMfa:
      case AuthenticatorStep.confirmSignInNewPassword:
      case AuthenticatorStep.resetPassword:
      case AuthenticatorStep.confirmResetPassword:
      case AuthenticatorStep.verifyUser:
      case AuthenticatorStep.confirmVerifyUser:
        child = _FormWrapperView(step: widget.step);
        break;
      case AuthenticatorStep.loading:
        throw StateError('Invalid step: $this');
    }

    if (isMobile) {
      double mobileWidth = MediaQuery.of(context).size.width;
      containerWidth = mobileWidth;

      child = SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(containerPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: containerWidth),
              child: SafeArea(child: child),
            ),
          ),
        ),
      );
    } else {
      containerWidth = AuthenticatorContainerConstants.mediumWidth;

      child = Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: containerWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: containerPadding),
                  child: Card(child: SafeArea(child: child)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(body: child),
    );
  }
}

class _FormWrapperView extends StatelessAuthenticatorComponent {
  const _FormWrapperView({
    Key? key,
    required this.step,
  }) : super(key: key);

  final AuthenticatorStep step;

  @override
  Widget builder(
    BuildContext context,
    AuthenticatorState state,
    AuthStringResolver stringResolver,
  ) {
    final titleResolver = stringResolver.titles;
    final form = InheritedForms.of(context)[step];
    final padding = InheritedConfig.of(context).padding;

    final Widget layout;
    switch (step) {
      case AuthenticatorStep.signIn:
      case AuthenticatorStep.signUp:
        layout = form;
        break;
      default:
        layout = Column(
          children: <Widget>[
            Text(
              titleResolver.resolve(context, step),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: AuthenticatorContainerConstants.gap,
            ),
            form,
          ],
        );
        break;
    }

    return Padding(padding: padding, child: layout);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AuthenticatorStep>('step', step));
  }
}

@visibleForTesting
class AuthenticatorTabView
    extends AuthenticatorComponent<AuthenticatorTabView> {
  const AuthenticatorTabView({
    Key? key,
    required this.tabs,
    this.initialIndex = 0,
  }) : super(key: key);

  final List<AuthenticatorStep> tabs;
  final int initialIndex;

  @override
  AuthenticatorComponentState<AuthenticatorTabView> createState() =>
      _AuthenticatorTabViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<AuthenticatorStep>('tabs', tabs));
    properties.add(IntProperty('initialIndex', initialIndex));
  }
}

class _AuthenticatorTabViewState
    extends AuthenticatorComponentState<AuthenticatorTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  AuthenticatorStep get selectedTab => widget.tabs[_controller.index];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: widget.initialIndex,
      length: widget.tabs.length,
      vsync: this,
    );
    _controller.addListener(_updateForm);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateForm() {
    // Update the Authenticator's internal state on tab changes.
    state.changeStep(selectedTab, context: context, reset: false);
  }

  Color getTabLabelColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = Theme.of(context).tabBarTheme.labelColor;
    final textColor = Theme.of(context).textTheme.bodySmall?.color;
    final fallbackColor = isDark ? Colors.white : Colors.black;
    return labelColor ?? textColor ?? fallbackColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          tabs: [
            for (var tab in widget.tabs)
              Tab(
                key: ValueKey(tab),
                text: stringResolver.buttons.resolve(context, tab.tabTitle),
              ),
          ],
          labelColor: getTabLabelColor(context),
        ),
        _FormWrapperView(step: selectedTab),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AuthenticatorStep>('selectedTab', selectedTab));
  }
}

extension on AuthenticatorStep {
  ButtonResolverKey get tabTitle {
    switch (this) {
      case AuthenticatorStep.onboarding:
      case AuthenticatorStep.signUp:
        return ButtonResolverKey.signUp;
      case AuthenticatorStep.signIn:
        return ButtonResolverKey.signIn;
      case AuthenticatorStep.confirmSignUp:
      case AuthenticatorStep.confirmSignInCustomAuth:
      case AuthenticatorStep.confirmSignInMfa:
      case AuthenticatorStep.confirmSignInNewPassword:
      case AuthenticatorStep.resetPassword:
      case AuthenticatorStep.confirmResetPassword:
      case AuthenticatorStep.verifyUser:
      case AuthenticatorStep.confirmVerifyUser:
      case AuthenticatorStep.loading:
        throw StateError('Invalid step: $this');
    }
  }
}
