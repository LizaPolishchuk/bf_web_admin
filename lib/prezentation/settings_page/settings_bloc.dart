// import 'dart:async';
//
// import 'package:rxdart/rxdart.dart';
// import 'package:bf_network_module/bf_network_module.dart';
//
// class SettingsBloc {
//   final ChangePasswordUseCase _changePasswordUseCase;
//
//   SettingsBloc(this._changePasswordUseCase);
//
//   final _passwordChangedSubject = PublishSubject<bool>();
//   final _errorSubject = PublishSubject<String>();
//   final _isLoadingSubject = PublishSubject<bool>();
//
//   // output stream
//   Stream<bool> get passwordChanged => _passwordChangedSubject.stream;
//
//   Stream<String> get errorMessage => _errorSubject.stream;
//
//   Stream<bool> get isLoading => _isLoadingSubject.stream;
//
//   changePassword(String oldPassword, String newPassword) async {
//     var response = await _changePasswordUseCase(oldPassword, newPassword);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _passwordChangedSubject.add(true);
//     }
//   }
//
//   dispose() {}
// }
