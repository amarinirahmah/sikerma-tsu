import 'package:flutter/material.dart';

class AppState {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  static final ValueNotifier<String> role = ValueNotifier(
    'guest',
  ); // admin, user, userpkl
  static final ValueNotifier<String?> token = ValueNotifier(null);

  static void loginAs(String newRole, String? newToken) {
    isLoggedIn.value = true;
    role.value = newRole;
    token.value = newToken;
    print('AppState.loginAs => role: $newRole, token: $newToken');
  }

  static void logout() {
    isLoggedIn.value = false;
    role.value = 'guest';
    token.value = null;
    print('AppState.logout => role: guest, token: null');
  }
}

// import 'package:flutter/material.dart';

// class AppState {
//   static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
//   static final ValueNotifier<String> role = ValueNotifier('guest');
//   static String? token;

//   static Future<void> loginAs(String newToken, String newRole) async {
//     token = newToken;
//     isLoggedIn.value = true;
//     role.value = newRole;
//   }

//   static Future<void> logout() async {
//     token = null;
//     isLoggedIn.value = false;
//     role.value = 'guest';
//   }
// }
