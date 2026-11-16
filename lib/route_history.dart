import 'package:flutter/widgets.dart';

class RouteHistory extends NavigatorObserver {
  RouteHistory._();
  static final RouteHistory instance = RouteHistory._();
  final List<String> _names = [];

  String? get previousName => _names.length > 1 ? _names[_names.length - 2] : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name;
    if (name != null) _names.add(name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final name = route.settings.name;
    if (name != null) {
      final index = _names.lastIndexOf(name);
      if (index >= 0) _names.removeAt(index);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final name = route.settings.name;
    if (name != null) {
      final index = _names.lastIndexOf(name);
      if (index >= 0) _names.removeAt(index);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final oldName = oldRoute?.settings.name;
    if (oldName != null) {
      final index = _names.lastIndexOf(oldName);
      if (index >= 0) _names.removeAt(index);
    }
    final newName = newRoute?.settings.name;
    if (newName != null) _names.add(newName);
  }
}
