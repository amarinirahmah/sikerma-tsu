import 'package:flutter/material.dart';

class AppState {
  static ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  static ValueNotifier<String> role = ValueNotifier(
    'guest',
  ); // 'admin', 'user', 'user_pkl'
}
