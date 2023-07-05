import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorParser {
  static final ErrorParser _singleton = ErrorParser._internal();

  static late AppLocalizations _appLocalizations;

  factory ErrorParser() {
    return _singleton;
  }

  ErrorParser._internal();

  void updateLocale(Locale locale) async {
    var languageCode = locale.languageCode;
    if (languageCode.contains("-")) {
      languageCode = languageCode.split("-").first;
    } else if (languageCode.contains("_")) {
      languageCode = languageCode.split("_").first;
    }

    _appLocalizations = await AppLocalizations.delegate.load(Locale(languageCode));
  }

  static String parseError(error) {
    if (error is NoInternetException) {
      return _appLocalizations.noInternetConnection;
    }
    if (error is DioError) {
      var detailMessage = error.response?.data["detail"];
      if (detailMessage != null && detailMessage.runtimeType == String) {
        debugPrint("DioError detail: $detailMessage");
        return detailMessage;
      } else {
        debugPrint("DioError message: $detailMessage");
        return error.message;
      }
    } else if (error is FirebaseAuthException) {
      return _parseFirebaseError(error);
    } else {
      debugPrint("Error: $error");
      return _appLocalizations.somethingWrong;
    }
  }

  static String _parseFirebaseError(FirebaseAuthException e) {
    String errorMessage;

    if (e.code == 'user-not-found') {
      errorMessage = _appLocalizations.noUserFound;
    } else if (e.code == 'wrong-password') {
      errorMessage = _appLocalizations.wrongPassword;
    } else if (e.code == 'weak-password') {
      errorMessage = _appLocalizations.weakPassword;
    } else if (e.code == 'email-already-in-use') {
      errorMessage = _appLocalizations.emailAlreadyInUse;
    } else if (e.code == 'invalid-email') {
      errorMessage = _appLocalizations.invalidEmail;
    } else if (e.message?.isNotEmpty == true) {
      errorMessage = e.message!;
    } else {
      errorMessage = _appLocalizations.somethingWrong;
    }

    debugPrint("Firebase error: ${e.code}, ${e.message}");
    return errorMessage;
  }
}
