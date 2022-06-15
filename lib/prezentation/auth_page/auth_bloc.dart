import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_adminka/event_bus_events/event_bus.dart';
import 'package:salons_adminka/event_bus_events/user_logout_event.dart';
import 'package:salons_adminka/event_bus_events/user_success_logged_in_event.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class AuthBloc {
  final LoginWithGoogleUseCase _loginWithGoogle;
  final LoginWithEmailAndPasswordUseCase _loginWithEmailAndPasswordUseCase;
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPasswordUseCase;
  final SignOutUseCase _signOut;

  AuthBloc(
      this._loginWithGoogle,
      this._loginWithEmailAndPasswordUseCase,
      this._signUpWithEmailAndPasswordUseCase,
      this._signOut);

  final _loggedInSuccessSubject = PublishSubject<bool>();
  final _registeredSuccessSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get loggedInSuccess => _loggedInSuccessSubject.stream;

  Stream<bool> get registeredSuccess => _registeredSuccessSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  login(String email, String password) async {
    // print()
    var response = await _loginWithEmailAndPasswordUseCase(email, password);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      eventBus.fire(UserSuccessLoggedInEvent());
      _loggedInSuccessSubject.add(true);
    }
  }

  loginViaGoogle() async {
    var response = await _loginWithGoogle();
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      eventBus.fire(UserSuccessLoggedInEvent());
      _loggedInSuccessSubject.add(true);
    }
  }

  register(String email, String password) async {
    var response = await _signUpWithEmailAndPasswordUseCase(email, password);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      eventBus.fire(UserSuccessLoggedInEvent());
      _registeredSuccessSubject.add(true);
    }
  }

  logout() async {
    var response = await _signOut();
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      eventBus.fire(UserLoggedOutEvent());
    }
  }

  dispose() {}
}
