import 'package:flutter_test/flutter_test.dart';
import 'package:mynote_app/services_auth/auth_exception.dart';
import 'package:mynote_app/services_auth/auth_provider.dart';
import 'package:mynote_app/services_auth/auth_user.dart';


void main(){
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialize to bigin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to initialize', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('Should be able to initialize in a less than 2 sec', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should delegate to login function', () async {
     final badEmailUser =  provider.createUser(email: 'foo@ar.com', password: 'foobar');

      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

     final badPasswordUser =  provider.createUser(email: 'someone@ar.com', password: 'anypassword');

     expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

     final user = await provider.createUser(email: 'foo', password: 'bar');

     expect(provider.currentUser, user);
    expect(user!.isEmailVerified, false);


    });
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);

    });

    test('Should be able to login and log out again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });



}

class NotInitializedException implements Exception{}


class MockAuthProvider implements AuthProvider{
  AuthUser? _user;

  var _isInitialized = false;

 bool get isInitialized => _isInitialized;


  @override
  Future<AuthUser?> createUser({required String email, required String password}) async{
   if(!isInitialized) throw NotInitializedException();
  await Future.delayed(const Duration(seconds: 1));
   return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser?> logIn({required String email, required String password}) async{
    if(!isInitialized) throw NotInitializedException();
    if(email == 'foo@ar.com') throw UserNotFoundAuthException();
    if(password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    await Future.value(user);
  }

  @override
  Future<AuthUser?> logOut()  async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser?> sendEmailVerification() async{
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
  const newUser = AuthUser(isEmailVerified:true);
  _user = newUser;
  }

}