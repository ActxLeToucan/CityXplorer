import 'package:flutter/material.dart';

class MyRouteInformationParser
    extends RouteInformationParser<List<RouteSettings>> {
  const MyRouteInformationParser() : super();

  @override
  Future<List<RouteSettings>> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/')]);
    }

    String path =
        uri.pathSegments.reduce((value, element) => "$value/$element");
    final routeSettings = [
      RouteSettings(
          name: '/$path',
          arguments: uri.queryParameters.isEmpty ? null : uri.queryParameters)
    ];

    return Future.value(routeSettings);
  }

  @override
  RouteInformation restoreRouteInformation(List<RouteSettings> configuration) {
    final location = configuration.last.name;
    final arguments = _restoreArguments(configuration.last);

    return RouteInformation(location: '$location$arguments');
  }

  String _restoreArguments(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/user':
        return '?pseudo=${(routeSettings.arguments as Map)['pseudo']}';
      case '/post':
        return '?id=${(routeSettings.arguments as Map)['id'].toString()}';
      case '/map':
        return '?id=${(routeSettings.arguments as Map)['id'].toString()}';
      case '/post/edit':
        return '?id=${(routeSettings.arguments as Map)['id'].toString()}';
      default:
        return '';
    }
  }
}
