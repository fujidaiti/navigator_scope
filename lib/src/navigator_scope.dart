// COPIED AND MODIFIED FROM flutter/lib/src/cupertino/tab_scaffold.dart
// CHANGES DONE:
// - Copy and rename [_TabSwitchingView] to [NavigatorScope]
// - Copy and rename [_TabSwitchingViewState] to [_NavigatorScopeState]
// - Rename some variables/methods

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
import 'package:navigator_scope/src/nested_navigator.dart';

/// A widget that manages a set of [NestedNavigator]s with a stack discipline.
class NavigatorScope extends StatefulWidget {
  const NavigatorScope({
    super.key,
    required this.currentDestination,
    required this.destinationCount,
    required this.destinationBuilder,
  }) : assert(destinationCount > 0);

  /// The index of the currently active destination.
  final int currentDestination;

  /// The number of destinations.
  ///
  /// Must be greater than 0.
  final int destinationCount;

  /// Creates a [NestedNavigator] to be managed by this [NavigatorScope].
  final IndexedWidgetBuilder destinationBuilder;

  @override
  State createState() => _NavigatorScopeState();
}

class _NavigatorScopeState extends State<NavigatorScope> {
  final List<bool> shouldBuildChildAt = [];
  final List<FocusScopeNode> destinationFocusNodes = [];

  // When focus nodes are no longer needed, we need to dispose of them, but we
  // can't be sure that nothing else is listening to them until this widget is
  // disposed of, so when they are no longer needed, we move them to this list,
  // and dispose of them when we dispose of this widget.
  final List<FocusScopeNode> discardedFocusNodes = [];

  @override
  void initState() {
    super.initState();
    shouldBuildChildAt.addAll(List.filled(widget.destinationCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveDestination();
  }

  @override
  void didUpdateWidget(NavigatorScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only partially invalidate the tabs cache to avoid breaking the current
    // behavior. We assume that the only possible change is either:
    // - new tabs are appended to the tab list, or
    // - some trailing tabs are removed.
    // If the above assumption is not true, some tabs may lose their state.
    final lengthDiff = widget.destinationCount - shouldBuildChildAt.length;
    if (lengthDiff > 0) {
      shouldBuildChildAt.addAll(List.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildChildAt.removeRange(
          widget.destinationCount, shouldBuildChildAt.length);
    }
    _focusActiveDestination();
  }

  // Will focus the active tab if the FocusScope above it has focus already. If
  // not, then it will just mark it as the preferred focus for that scope.
  void _focusActiveDestination() {
    if (destinationFocusNodes.length > widget.destinationCount) {
      discardedFocusNodes
          .addAll(destinationFocusNodes.sublist(widget.destinationCount));
      destinationFocusNodes.removeRange(
          widget.destinationCount, destinationFocusNodes.length);
    } else if (destinationFocusNodes.length < widget.destinationCount) {
      destinationFocusNodes.addAll(
        List.generate(
          widget.destinationCount - destinationFocusNodes.length,
          (int index) => FocusScopeNode(
            debugLabel:
                '$NestedNavigator ${index + destinationFocusNodes.length}',
          ),
        ),
      );
    }
    FocusScope.of(context)
        .setFirstFocus(destinationFocusNodes[widget.currentDestination]);
  }

  @override
  void dispose() {
    for (final focusScopeNode in destinationFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final focusScopeNode in discardedFocusNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(widget.destinationCount, (index) {
        final active = index == widget.currentDestination;
        shouldBuildChildAt[index] = active || shouldBuildChildAt[index];

        return HeroMode(
          enabled: active,
          child: Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: destinationFocusNodes[index],
                child: Builder(builder: (BuildContext context) {
                  return shouldBuildChildAt[index]
                      ? widget.destinationBuilder(context, index)
                      : const SizedBox.shrink();
                }),
              ),
            ),
          ),
        );
      }),
    );
  }
}
