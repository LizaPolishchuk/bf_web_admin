import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:rxdart/rxdart.dart';

class InitialBloc {
  final SalonRepository _salonRepository;

  InitialBloc(this._salonRepository);

  final _salonExistsSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();

  // output stream
  Stream<bool> get isSalonExists => _salonExistsSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Future<bool> checkIfSalonExists() async {
    try {
      return _salonRepository.checkIfSalonExists();
    } catch (error) {
      return Future.error(error);
    }
  }

  dispose() {}
}
