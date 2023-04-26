[![Pub](https://img.shields.io/pub/v/navigator_scope.svg?logo=flutter&color=blue&style=flat-square)](https://pub.dev/packages/navigator_scope) [![Docs](https://img.shields.io/badge/-API%20Reference-orange?style=flat-square)](https://pub.dev/documentation/navigator_scope/latest/)

# NavigatorScope

> 🤔 : Hmm, I wonder how to keep BottomNavigationBar fixed while transition in Flutter?
>
> 🌐 : [go_router](https://pub.dev/packages/go_router), [beamer](https://pub.dev/packages/beamer), [qlevar_router](https://pub.dev/packages/qlevar_router#nested-navigators), etc...
>
> 😵 : Wait, I just want a persistent nav bar, I don't need deep linking, URL based navigation, or back buttons for brower... Is there any other easy way?
>
> 🌐 : ...
>
> 🙄: 🤯
>
> 👼 : There's [navigator_scope](https://github.com/fujidaiti/navigator_scope), bro.



A simple package for nested navigation. No need to learn a bunch of new APIs. It will work exactly as you imagine.

![navigator_scope_demo](https://user-images.githubusercontent.com/68946713/234653804-c29aae3b-23b0-4740-be60-35696bf30fc3.gif)



## Pros & Cons

[Navigator 2.0](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade) is powerful and  [go_router](https://pub.dev/packages/go_router) is friendly. However, there are still cases where these tools are overkill, and in those cases traditional navigator APIs such as `pop` and `push` are more suitable due to its simplicity. This is where *navigator_scope* comes in. It extracts the nested navigation mechanism from [CupertinoTabScaffold](https://api.flutter.dev/flutter/cupertino/CupertinoTabScaffold-class.html) and makes it more generalized for use in MaterialDesign widgets. 

### Pros:

- **Simple to use**: You don't need to learn a bunch of new APIs.
- **Works with any tab based widgets**:  Since it is completely independent of tabs, it can be used not only with builtin tabs such as [BottomNavigationBar](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html) and [NavigationDrawer](https://api.flutter.dev/flutter/material/NavigationDrawer-class.html), but also a variety of third party packages like [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) and [curved_navigation_bar](https://pub.dev/packages/curved_navigation_bar).

### Cons:

- **Only supports non-named routes**: For simplicity, this package doesn't support `Navigator.pushNamed` or URL based routing. 

## Install

Available at [pub.dev](https://pub.dev/packages/navigator_scope).

```shell
flutter pub add navigator_scope
```

## Try it

There is an example app that uses this package with [NavigationBar](https://api.flutter.dev/flutter/material/NavigationBar-class.html).

```shell
git clone git@github.com:fujidaiti/navigator_scope.git
cd example
flutter pub get
flutter run
```

## Usage

Use `NestedNavigator` as a local navigator, and `NavigatorScope` as a hub of the navigators. `NavigatorScope` keeps the state of each tab even if it disappears after the transition.  If you want to change the active tab, just rebuild `NavigatorScope` with new `currentDestination`. That's all.

```dart
Scaffold(
  bottomNavigationBar: NavigationBar( // Use your favorite nav bar
    selectedIndex: selectedTabIndex,
    destinations: tabs,
    ...
  ),
  body: NavigatorScope( // A hub of local navigators
    currentDestination: selectedTabIndex,
    destinationCount: tabs.length,
    destinationBuilder: (context, index) {
      return NestedNavigator( // A local navigator
        // Create the default page for this navigator
        builder: (context) => Container(),
      );
    },
  ),
);
```

You can use `Navigator.push` to navigate to a new page, and `Navigate.pop` to go back. The other imperative navigation APIs such as `Navigator.popUntil` can also be used.

```dart
Navigator.of(context).push(...);
```

If you want to show a dialog that covers the entire screen, use the root navigator instead of a local navigator.

```dart
showDialog(
  context: context,
  useRootNavigator: true,
  ...,
);
```

## Questions

If you have any question, feel free to ask them on the [discussions page](https://github.com/fujidaiti/navigator_scope/discussions/categories/q-a).

## Contributing

If you find any bugs or have suggestions for improvement, please create an issue or a pull request on the GitHub repository. Contributions are welcome and appreciated!
