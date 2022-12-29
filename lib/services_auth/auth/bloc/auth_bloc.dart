import 'package:bloc/bloc.dart';
import '../auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoading(),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(
          AuthStateLoggedIn(user!),
        );
      } on Exception catch (e) {
        emit(AuthStateLoggedInFailure(e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      // provider is a async so so ui should be waited
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
      } on Exception catch (e) {
        emit(AuthStateLoggedOutFailure(e));
      }
    });
  }
}
