// COPIED AND MODIFIED FROM flutter/lib/src/cupertino/tab_view.dart
//
// Changes done:
// - Rename CupertinoTabView to NestedNavigator
// - Rename _CupertinoTabViewState to _NestedNavigatorState
// - Replace [CupertinoApp.createCupertinoHeroController] with
//   [MaterialApp.createMaterialHeroController] in [_CupertinoTabViewState.initState]
// - Remove unnessary properties

// Copyright 2014 The Flutter Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:navigator_scope/src/navigator_scope.dart';

/// A thin wrapper of a [Navigator], which manages an independent stack of pages
/// whithin a [NavigatorScope].
///
/// Only works with non-named routing APIs such as [Navigator.pop] and [Navigator.push].
class NestedNavigator extends StatefulWidget {
  /// Creates a [NestedNavigator] whose default route is
  /// a [MaterialPageRoute] constructed with [builder].
  ///
  /// If you want to use a custom [Route], see [NestedNavigator.routeBuilder].
  NestedNavigator({
    super.key,
    required WidgetBuilder builder,
    this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.restorationScopeId,
  }) : routeBuilder = ((context) {
          return MaterialPageRoute(
            builder: builder,
            settings: const RouteSettings(
              name: Navigator.defaultRouteName,
            ),
          );
        });

  /// Creates a [NestedNavigator] with the default route defined by [routeBuilder].
  const NestedNavigator.routeBuilder(
    this.routeBuilder, {
    super.key,
    this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.restorationScopeId,
  });

  // Builds the default route for this navigator.
  final Route Function(BuildContext context) routeBuilder;

  /// A key to use when building the internal [Navigator] of this widget.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The list of observers for this navigator.
  ///
  /// The observers is not shared with ancestor or descendant [Navigator]s.
  final List<NavigatorObserver> navigatorObservers;

  /// Restoration ID to save and restore the state of the internal [Navigator] of this widget.
  ///
  /// {@macro flutter.widgets.navigator.restorationScopeId}
  final String? restorationScopeId;

  @override
  State<NestedNavigator> createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<NestedNavigator> {
  late HeroController _heroController;
  late List<NavigatorObserver> _navigatorObservers;

  @override
  void initState() {
    super.initState();
    _heroController = MaterialApp.createMaterialHeroController();
    _updateObservers();
  }

  @override
  void didUpdateWidget(NestedNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorKey != oldWidget.navigatorKey ||
        widget.navigatorObservers != oldWidget.navigatorObservers) {
      _updateObservers();
    }
  }

  void _updateObservers() {
    _navigatorObservers = List<NavigatorObserver>.of(widget.navigatorObservers)
      ..add(_heroController);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      observers: _navigatorObservers,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    assert(
      settings.name == Navigator.defaultRouteName,
      '$NestedNavigator only supoprts imperative routing APIs',
    );
    return widget.routeBuilder(context);
  }

  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    throw StateError('$NestedNavigator only supoprts imperative routing APIs');
  }
}
