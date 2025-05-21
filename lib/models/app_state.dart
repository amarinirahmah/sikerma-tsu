// import 'package:flutter/material.dart';

// class AppState {
//   static ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
//   static ValueNotifier<String> role = ValueNotifier(
//     'guest',
//   ); // 'admin', 'user', 'user_pkl'
// }

import 'package:flutter/material.dart';

class AppState {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  static final ValueNotifier<String> role = ValueNotifier(
    'guest',
  ); // admin, user, userpkl

  static void loginAs(String newRole) {
    isLoggedIn.value = true;
    role.value = newRole;
  }

  static void logout() {
    isLoggedIn.value = false;
    role.value = 'guest';
  }
}
