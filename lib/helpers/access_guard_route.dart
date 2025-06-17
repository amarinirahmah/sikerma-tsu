import 'package:flutter/material.dart';
import 'package:sikermatsu/states/app_state.dart';
import 'package:sikermatsu/pages/guard/access_denied_page.dart';

Route<dynamic> guardedRoute({
  required WidgetBuilder builder,
  required List<String> allowedRoles,
  required RouteSettings settings,
}) {
  final currentRole = AppState.role.value;

  if (!allowedRoles.contains(currentRole)) {
    return MaterialPageRoute(
      builder: (_) => const AccessDeniedPage(),
      settings: settings,
    );
  }

  return MaterialPageRoute(builder: builder, settings: settings);
}
