import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

class AuthenticatorRouter extends StatelessWidget {
  AuthenticatorRouter({
    super.key,
  }) : _routeInformationProvider = _platformProvider;

  AuthenticatorRouter.fromRouterConfig({
    super.key,
    required RouterConfig<Object> config,
  }) : _routeInformationProvider = config.routeInformationProvider!;

  const AuthenticatorRouter.fromRouteInformationProvider({
    super.key,
    required RouteInformationProvider routeInformationProvider,
  }) : _routeInformationProvider = routeInformationProvider;

  final RouteInformationProvider _routeInformationProvider;

  static final _delegate = AuthenticatorRouterDelegate();

  static final _parser = AuthenticatorRouteInformationParser();

  static final _platformProvider = PlatformRouteInformationProvider(
    initialRouteInformation: const RouteInformation(location: '/'),
  );

  @override
  Widget build(BuildContext context) {
    return Router<RouteInformation>(
      key: key,
      routeInformationProvider: _routeInformationProvider,
      routeInformationParser: _parser,
      routerDelegate: _delegate,
    );
  }
}

class AuthenticatorRouterDelegate implements RouterDelegate<RouteInformation> {
  @override
  void addListener(VoidCallback listener) {}

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case AuthenticatorStep.signUp:
        return const AuthenticatorScreen.signUp();
      case AuthenticatorStep.signIn:
        return const AuthenticatorScreen.signIn();
      case AuthenticatorStep.confirmSignUp:
        return const AuthenticatorScreen.confirmSignUp();
      case AuthenticatorStep.resetPassword:
        return const AuthenticatorScreen.resetPassword();
      case AuthenticatorStep.confirmResetPassword:
      default:
        // TODO: Implement remaining steps
        throw StateError('Unhandled step $currentStep');
    }
  }

  @override
  RouteInformation get currentConfiguration => _info;
  RouteInformation _info = const RouteInformation();

  AuthenticatorStep get currentStep {
    if (currentConfiguration.location == null) {
      return AuthenticatorStep.signIn;
    }
    final url =
        currentConfiguration.location!.replaceFirst('/auth/', '').split('?')[0];
    switch (url) {
      case 'sign-up':
        return AuthenticatorStep.signUp;
      case 'confirm-sign-up':
        return AuthenticatorStep.confirmSignUp;
      case 'forgot-password':
        return AuthenticatorStep.resetPassword;
      // TODO: Implement remaining steps
      default:
        return AuthenticatorStep.signIn;
    }
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setInitialRoutePath(configuration) async {
    _info = configuration;
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    _info = configuration;
  }

  @override
  Future<void> setRestoredRoutePath(configuration) async {
    _info = configuration;
  }
}

class AuthenticatorRouteInformationParser
    implements RouteInformationParser<RouteInformation> {
  @override
  Future<RouteInformation> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    return Future.sync(() => routeInformation);
  }

  @override
  Future<RouteInformation> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    return Future.sync(() => routeInformation);
  }

  @override
  RouteInformation? restoreRouteInformation(RouteInformation configuration) {
    return null;
  }
}
