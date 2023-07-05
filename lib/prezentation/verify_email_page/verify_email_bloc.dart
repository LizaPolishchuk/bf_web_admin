import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:rxdart/rxdart.dart';

class VerifyEmailBloc {
  final AuthRepository _authRepository;
  final AdminRepository _adminRepository;
  final MediaRepository _mediaRepository;

  late Timer _timer;

  VerifyEmailBloc(this._authRepository, this._adminRepository, this._mediaRepository) {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  final _emailVerifiedSubject = PublishSubject<bool>();
  final _registeredSuccessSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _errorUserCreateSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get emailVerified => _emailVerifiedSubject.stream;

  Stream<bool> get registeredSuccess => _registeredSuccessSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<String> get errorUserCreation => _errorUserCreateSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  createAdmin() async {
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        var response = await _adminRepository.createAdmin(
          WebAdmin("Liza", "Admin", email),
        );

        var photoResponse = await _mediaRepository.getSignedUrl(
          SignedUrlRequest(
            response.uuid!,
            PhotoType.user,
          ),
        );
        
        print("signedUrl: ${photoResponse}");
      }
    } catch (error) {
      _errorUserCreateSubject.add(ErrorParser.parseError(error));
    }
  }

  sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        var actionCodeSettings = ActionCodeSettings(
          url: 'https://localhost:62764/?email=${user.email}',
          dynamicLinkDomain: 'bfree-web.firebaseapp.com',
          handleCodeInApp: false,
        );

        await FirebaseAuth.instance.currentUser?.sendEmailVerification(actionCodeSettings);
      }
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified) {
      _emailVerifiedSubject.add(true);

      createAdmin();

      _timer.cancel();
    }
  }

  logout() async {
    try {
      await _authRepository.signOut();
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {
    _timer.cancel();
  }
}
