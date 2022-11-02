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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/src/matching.dart';

/// {@template amplify_authenticator.merged_router_config}
/// A [RouterConfig] created from two other configs, one of which is type
/// [GoRouter].
/// {@endtemplate}
class MergedRouterConfig implements RouterConfig<Object> {
  /// {@macro amplify_authenticator.merged_router_config}
  const MergedRouterConfig({
    required this.authenticatorRouterConfig,
    required this.otherConfig,
  });

  final GoRouter authenticatorRouterConfig;

  final RouterConfig<Object> otherConfig;

  @override
  // TODO: Should authenticatorRouterConfig be considered?
  BackButtonDispatcher? get backButtonDispatcher =>
      otherConfig.backButtonDispatcher;

  @override
  RouteInformationParser<Object> get routeInformationParser =>
      MergedRouteInformationParser(
        authenticatorRouterParser:
            authenticatorRouterConfig.routeInformationParser,
        otherParser: otherConfig.routeInformationParser,
      );

  @override
  RouteInformationProvider? get routeInformationProvider =>
      MergedRouteInformationProvider(
        authenticatorRouterProvider:
            authenticatorRouterConfig.routeInformationProvider,
        otherProvider: otherConfig.routeInformationProvider,
      );

  @override
  RouterDelegate<Object> get routerDelegate => MergedRouterDelegate(
        authenticatorRouterDelegate: authenticatorRouterConfig.routerDelegate,
        otherDelegate: otherConfig.routerDelegate,
      );
}

class MergedRouteInformationParser implements RouteInformationParser<Object> {
  const MergedRouteInformationParser({
    required this.authenticatorRouterParser,
    required this.otherParser,
  });

  final RouteInformationParser<RouteMatchList> authenticatorRouterParser;

  final RouteInformationParser<Object>? otherParser;

  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    // Parse route info using the authenticator's config
    final authenticatorRouterInfo =
        await authenticatorRouterParser.parseRouteInformation(
      routeInformation,
    );

    // If there is no error, a route was found, and the info should be returned.
    // If `otherParser` is null, the customer's config doesn't have a parser,
    // so the info should be returned anyway.
    // TODO: Consider how to handle errors that are not due to a missing route.
    // TODO: Warn customer that they have not definied a parser, and therefore
    // the authenticators error handling will be used for missing routes.
    if (!authenticatorRouterInfo.isError || otherParser == null) {
      return authenticatorRouterInfo;
    }

    // Parse and return the info from the customer's router.
    // TODO: This presents an issue for redirects (route guards).
    // When a redirect happens from a customer defined route (/profile) to an
    // authenticator defined route (/sign-in), there is no way to know that this
    // redirect took place, or that the customer's router doesn't have a route
    // defined for the new route without knowing what type otherRouterInfo is.
    // If otherRouterInfo was type RouteMatchList (from GoRouter), we could
    // check to see if otherRouterInfo.matches[0].fullPath matches
    // routeInformation.location to see that there was a redirect, and then
    // otherRouterInfo.isError to see if there was a match for this new route.
    // If there was a redirect and there was no match for the new route, we
    // could then re-parse the new route info with authenticatorRouterParser.
    final otherRouterInfo = await otherParser!.parseRouteInformation(
      routeInformation,
    );
    return otherRouterInfo;
  }

  @override
  Future<Object> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    // Parse route info using the authenticator's config first.
    final authenticatorRouterInfo =
        await authenticatorRouterParser.parseRouteInformationWithDependencies(
      routeInformation,
      context,
    );

    // If there is no error, a route was found, and the info should be returned.
    // If `otherParser` is null, the customer's config doesn't have a parser,
    // so the info should be returned regardless of an error.
    // TODO: Consider how to handle errors that are not due to a missing route.
    // TODO: Warn customer that they have not definied a parser, and therefore
    // the authenticator's error handling will be used for missing routes.
    if (!authenticatorRouterInfo.isError || otherParser == null) {
      return authenticatorRouterInfo;
    }

    // Parse and return the info from the customer's router.
    // TODO: This presents an issue for redirects (route guards).
    // When a redirect happens from a customer defined route (/profile) to an
    // authenticator defined route (/sign-in), there is no way to know that this
    // redirect took place, or that the customer's router doesn't have a route
    // defined for the new route without knowing what type otherRouterInfo is.
    // If otherRouterInfo was type RouteMatchList (from GoRouter), we could
    // check to see if otherRouterInfo.matches[0].fullPath matches
    // routeInformation.location to see that there was a redirect, and then
    // otherRouterInfo.isError to see if there was a match for this new route.
    // If there was a redirect and there was no match for the new route, we
    // could then re-parse the new route info with authenticatorRouterParser.
    final otherRouterInfo =
        await otherParser!.parseRouteInformationWithDependencies(
      routeInformation,
      context,
    );
    return otherRouterInfo;
  }

  @override
  RouteInformation? restoreRouteInformation(Object configuration) {
    if (configuration is RouteMatchList) {
      return authenticatorRouterParser.restoreRouteInformation(configuration);
    }
    return otherParser?.restoreRouteInformation(configuration);
  }
}

class MergedRouteInformationProvider extends RouteInformationProvider {
  MergedRouteInformationProvider({
    required this.authenticatorRouterProvider,
    required this.otherProvider,
  });

  final RouteInformationProvider authenticatorRouterProvider;

  final RouteInformationProvider? otherProvider;

  @override
  void addListener(VoidCallback listener) {
    otherProvider?.addListener(listener);
    authenticatorRouterProvider.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    otherProvider?.removeListener(listener);
    authenticatorRouterProvider.removeListener(listener);
  }

  @override
  // TODO: Should this be merged? They are likely the same value.
  RouteInformation get value =>
      otherProvider?.value ?? authenticatorRouterProvider.value;

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    // TODO: Figure out how to combine these. Probably should not run both, as
    // they may both modify the browsers history.
    authenticatorRouterProvider.routerReportsNewRouteInformation(
      routeInformation,
    );
    otherProvider?.routerReportsNewRouteInformation(routeInformation);
  }
}

class MergedRouterDelegate implements RouterDelegate<Object> {
  const MergedRouterDelegate({
    required this.authenticatorRouterDelegate,
    required this.otherDelegate,
  });

  final RouterDelegate authenticatorRouterDelegate;

  final RouterDelegate otherDelegate;

  @override
  void addListener(VoidCallback listener) {
    otherDelegate.addListener(listener);
    authenticatorRouterDelegate.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Figure out how to comine these.
    // Note: This doesn't seem to be causing an issue. Possibly because both
    // router configs are GoRouter so both build methods are the same?
    return otherDelegate.build(context);
  }

  @override
  Future<bool> popRoute() async {
    final otherPopResult = await otherDelegate.popRoute();
    final authenticatorRouterPopResult =
        await authenticatorRouterDelegate.popRoute();
    return otherPopResult || authenticatorRouterPopResult;
  }

  @override
  void removeListener(VoidCallback listener) {
    otherDelegate.removeListener(listener);
    authenticatorRouterDelegate.removeListener(listener);
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {
    await otherDelegate.setNewRoutePath(configuration);
    await authenticatorRouterDelegate.setNewRoutePath(configuration);
  }

  @override
  Object? get currentConfiguration =>
      authenticatorRouterDelegate.currentConfiguration ??
      otherDelegate.currentConfiguration;

  @override
  Future<void> setInitialRoutePath(Object configuration) {
    // Use the customer's config to set the initial path.
    return otherDelegate.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setRestoredRoutePath(Object configuration) {
    // TODO: Should Authenticator config be considered?
    return otherDelegate.setRestoredRoutePath(configuration);
  }
}
