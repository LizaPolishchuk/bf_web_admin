import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_adminka/utils/error_parser.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

enum AppointmentsType { salon, master }

class AppointmentsBloc {
  final AppointmentRepository _appointmentRepository;

  AppointmentsBloc(this._appointmentRepository);

  final _appointmentsLoadedSubject = BehaviorSubject<List<AppointmentEntity>>();
  final _appointmentAddedSubject = PublishSubject<bool>();
  final _appointmentUpdatedSubject = PublishSubject<bool>();
  final _appointmentRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<AppointmentEntity>> get appointmentsLoaded => _appointmentsLoadedSubject.stream;

  Stream<bool> get appointmentAdded => _appointmentAddedSubject.stream;

  Stream<bool> get appointmentUpdated => _appointmentUpdatedSubject.stream;

  Stream<bool> get appointmentRemoved => _appointmentRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getAppointments(String uuid, AppointmentsType appointmentsType) async {
    try {
      List<AppointmentEntity> response;
      switch (appointmentsType) {
        case AppointmentsType.salon:
          response = await _appointmentRepository.getSalonAppointments(uuid);
          break;
        case AppointmentsType.master:
          response = await _appointmentRepository.getMasterAppointments(uuid);
          break;
      }

      _appointmentsLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  addAppointment(CreateAppointmentRequest appointmentRequest) async {
    try {
      var appointment = await _appointmentRepository.createAppointment(appointmentRequest);

      _appointmentsLoadedSubject.add(_appointmentsLoadedSubject.value..add(appointment));
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  updateAppointment(String appointmentId, CreateAppointmentRequest appointmentRequest) async {
    try {
      var appointment = await _appointmentRepository.updateAppointment(appointmentId, appointmentRequest);

      var appointmentsList = _appointmentsLoadedSubject.value;
      appointmentsList[appointmentsList.indexOf(appointment)] = appointment;

      _appointmentsLoadedSubject.add(appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  changeAppointmentStartTime(String appointmentId, int startTime) async {
    try {
      var response = await _appointmentRepository.changeAppointmentStartTime(appointmentId, startTime);

      // var appointmentsList = _appointmentsLoadedSubject.value;
      // int index = appointmentsList.indexWhere((element) => element.id == appointmentId);
      // var appointment = appointmentsList[index];
      // var newAppointment = appointment.copy(startTime: startTime);
      // appointmentsList[index] = newAppointment;
      //
      // _appointmentsLoadedSubject.add(appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  removeAppointment(String appointmentId) async {
    try {
      var response = await _appointmentRepository.deleteAppointment(appointmentId);

      var appointmentsList = _appointmentsLoadedSubject.value;
      appointmentsList.removeWhere((element) => element.id == appointmentId);

      _appointmentsLoadedSubject.add(appointmentsList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }
}
