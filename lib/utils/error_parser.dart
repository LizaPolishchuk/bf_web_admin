import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:salons_adminka/l10n/l10n.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ErrorParser {
  static final ErrorParser _singleton = ErrorParser._internal();

  static late AppLocalizations _appLocalizations;

  factory ErrorParser() {
    _createAppLocalizations();
    return _singleton;
  }

  ErrorParser._internal();

  static void _createAppLocalizations() async {
    _appLocalizations = await AppLocalizations.delegate.load(Get.locale ?? L10n.defaultLocale);
  }

  void updateLocale(Locale locale) async {
    _appLocalizations = await AppLocalizations.delegate.load(locale);
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
    } else {
      debugPrint("Error: $error");
      return _appLocalizations.somethingWentWrong;
    }
  }
}
