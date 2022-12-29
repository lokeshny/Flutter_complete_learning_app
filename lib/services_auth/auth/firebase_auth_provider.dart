

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mynote_app/services_auth/auth/auth_provider.dart';

import '../../firebase_options.dart';
import 'auth_exception.dart';
import 'auth_user.dart';


class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser?> createUser({required String email, required String password})  async {

   try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    final user = currentUser;
    if(user != null){
      return user;
    }else{
      throw UserNotFoundAuthException();
    }
   } on FirebaseAuthException catch(e){
     if (e.code == 'weak-password') {
       throw WeakPassWordException();
     } else if (e.code == 'email-already-in-use') {
       throw EmailAlreadyInUseException();
     } else if (e.code == 'invalid-email') {
     } else {
       throw GenericAuthException();
     }

   } catch(_){
     throw GenericAuthException();
   }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    }else{
      return null;
    }
  }

  @override
  Future<AuthUser?> logIn({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final user = currentUser;
      print(user);
      if(user != null){
        return user;

      }else{
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        throw UserNotFoundAuthException();

      } else if(e.code == 'wrong-password'){
        throw WrongPasswordAuthException();

      } else{
        throw GenericAuthException();
      }

    } catch(_){
      throw GenericAuthException();
    }
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> logOut() async{
   final user = FirebaseAuth.instance.currentUser;

   if(user != null){
     FirebaseAuth.instance.signOut();
   } else{
     throw UserNotLoggedInAuthException();
   }
  }

  @override
  Future<AuthUser?> sendEmailVerification() async {

    final user = FirebaseAuth.instance.currentUser;

    if(user != null){
      await user.sendEmailVerification();
    } else {
      UserNotFoundAuthException();
    }
    // TODO: implement sendEmailVerification
  //  throw UnimplementedError();
  }


    @override
    Future<void> initialize() async {
      Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  
  
}