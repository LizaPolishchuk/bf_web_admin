import 'package:flutter/material.dart';

class Loader {
  static bool _isLoaderVisible = false;

  static void showLoader(BuildContext context) {
    _isLoaderVisible = true;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    if(_isLoaderVisible) {
      Navigator.of(context).pop();
    }
  }
}
