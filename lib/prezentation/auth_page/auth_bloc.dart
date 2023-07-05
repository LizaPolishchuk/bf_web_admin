import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/verify_email_page/verify_email_bloc.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final AuthRepository _authRepository;
  final SalonRepository _salonRepository;

  AuthBloc(this._authRepository, this._salonRepository);

  final _loggedInSuccessSubject = PublishSubject<bool>();
  final _registeredSuccessSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get loggedInSuccess => _loggedInSuccessSubject.stream;

  Stream<bool> get registeredSuccess => _registeredSuccessSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  register(String email, String password) async {
    try {
      await _authRepository.signUpWithEmailAndPassword(email, password);

      getIt<VerifyEmailBloc>().createAdmin();

      // "User with uuid already exists"
      // await _adminRepository.createAdmin(
      //   WebAdmin("Liza", "Admin", email),
      // );
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  login(String email, String password) async {
    try {
      await _authRepository.loginWithEmailAndPassword(email, password);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  loginViaGoogle() async {
    try {
      await _authRepository.loginWithGoogle();
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  logout() async {
    try {
      print("logout");
      await _authRepository.signOut();
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
