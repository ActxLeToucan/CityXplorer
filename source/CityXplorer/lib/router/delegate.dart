import 'package:cityxplorer/pages/change_password.dart';
import 'package:cityxplorer/pages/edit_profile.dart';
import 'package:cityxplorer/pages/login_screen.dart';
import 'package:cityxplorer/pages/main_interface.dart';
import 'package:cityxplorer/pages/map-screen.dart';
import 'package:cityxplorer/pages/new_post.dart';
import 'package:cityxplorer/pages/user_profile.dart';
import 'package:cityxplorer/pages/validation_post.dart';
import 'package:cityxplorer/router/transition_delegate.dart';
import 'package:flutter/material.dart';

import '../pages/create_account.dart';
import '../pages/credit_page.dart';
import '../pages/post_edit.dart';
import '../pages/post_page.dart';
import '../pages/search_page.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
      transitionDelegate: const MyTransitionDelegate(),
    );
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }

    return _confirmAppExit();
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());
    return Future.value(null);
  }

  void parseRoute(Uri uri) {
    if (uri.hasFragment) {
      uri = Uri.parse(uri.toString().replaceFirst("#/", ""));
    }
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath([const RouteSettings(name: '/')]);
    } else {
      String path =
          uri.pathSegments.reduce((value, element) => "$value/$element");
      setNewRoutePath([
        RouteSettings(
            name: '/$path',
            arguments: uri.queryParameters.isEmpty ? null : uri.queryParameters)
      ]);
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();
    return true;
  }

  void _setPath(List<Page> pages) {
    _pages.clear();
    _pages.addAll(pages);

    if (_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }
    notifyListeners();
  }

  void pushPage({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void pushPageAndClear({required String name, dynamic arguments}) {
    _pages.clear();
    pushPage(name: name, arguments: arguments);
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case '/':
        child = const MainInterface();
        break;
      case '/login':
        child = const LoginScreen();
        break;
      case '/signup':
        child = const CreateNewAccount();
        break;
      case '/user':
        child = UserProfile(
            arguments: routeSettings.arguments as Map<String, String>);
        break;
      case '/edit_profile':
        child = const EditProfilePage();
        break;
      case '/change_password':
        child = const ChangePassword();
        break;
      case '/search':
        child = const SearchPage();
        break;
      case '/post':
        child =
            PostPage(arguments: routeSettings.arguments as Map<String, String>);
        break;
      case '/post/edit':
        child =
            PostEdit(arguments: routeSettings.arguments as Map<String, String>);
        break;
      case '/map':
        child = GeolocationMap(
            arguments: routeSettings.arguments as Map<String, String>);
        break;
      case '/credit':
        child = CreditPage();
        break;
      case '/validationPost':
        child = ValidationPost();
        break;
      case '/new_post':
        child = NewPostScreen(
            arguments: routeSettings.arguments as Map<String, String>);
        break;
      default:
        if (routeSettings.name != null &&
            routeSettings.name!.startsWith("/download")) {
          child = Scaffold(
            appBar: AppBar(title: const Text("CityXplorer"), centerTitle: true),
            body: const Center(
                child: Text(
                    "Vous possédez déjà cette application.\nPour mettre à jour l'application, désinstallez la et relancez le fichier d'installation.",
                    textAlign: TextAlign.center)),
          );
          break;
        }
        child = Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: const Center(
              child: Text('Page introuvable', textAlign: TextAlign.center)),
        );
    }

    return MaterialPage(
      child: child,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  Future<bool> _confirmAppExit() async {
    final result = await showDialog<bool>(
        context: navigatorKey!.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Quitter l'application"),
            content: const Text(
                "Voulez-vous vraiment quitter l'application CityXplorer ?"),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: const Text('Confirmer'),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          );
        });

    return result ?? true;
  }
}
