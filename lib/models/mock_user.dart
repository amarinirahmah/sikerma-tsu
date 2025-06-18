Future<Map<String, dynamic>?> dummyLogin(String email, String password) async {
  await Future.delayed(const Duration(seconds: 1)); // simulasi delay network

  // Data dummy
  const dummyEmail = 'amarini@gmail.com';
  const dummyPassword = 'admin1';

  if (email == dummyEmail && password == dummyPassword) {
    return {
      'token': 'tokenadmin1',
      'user': {'name': 'Amarini', 'email': dummyEmail, 'role': 'userpkl'},
    };
  }

  return null;
}
