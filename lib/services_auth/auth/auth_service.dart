import 'package:mynote_app/services_auth/auth/auth_provider.dart';
import 'package:mynote_app/services_auth/auth/firebase_auth_provider.dart';

import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase()=> AuthService(FirebaseAuthProvider(),
  );

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<AuthUser?> logOut() => provider.logOut();

  @override
  Future<AuthUser?> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

}
