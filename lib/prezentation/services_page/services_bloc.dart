import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_adminka/utils/error_parser.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesBloc {
  final ServiceRepository _serviceRepository;
  final SalonRepository _salonRepository;

  ServicesBloc(this._serviceRepository, this._salonRepository);

  List<Service> _servicesList = [];

  final _servicesLoadedSubject = PublishSubject<List<Service>>();
  final _serviceAddedSubject = PublishSubject<bool>();
  final _serviceUpdatedSubject = PublishSubject<bool>();
  final _serviceRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<Service>> get servicesLoaded => _servicesLoadedSubject.stream;

  Stream<bool> get serviceAdded => _serviceAddedSubject.stream;

  Stream<bool> get serviceUpdated => _serviceUpdatedSubject.stream;

  Stream<bool> get serviceRemoved => _serviceRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getServices(String salonId, String? categoryId) async {
    try {
      var response = await _salonRepository.getSalonServices(salonId);
      _servicesList = response;
      _servicesLoadedSubject.add(_servicesList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  searchServices(String searchKey) async {
    print("searchServices: $searchKey");

    if (searchKey.isEmpty) {
      _servicesLoadedSubject.add(_servicesList);
    }

    List<Service> searchedList = [];
    for (var service in _servicesList) {
      if (service.name.toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(service);
      }
    }

    _servicesLoadedSubject.add(searchedList);
  }

  addService(Service service) async {
    try {
      var response = await _serviceRepository.createService(service);
      _servicesList.add(service);
      _servicesLoadedSubject.add(_servicesList);
      _serviceAddedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  updateService(Service service, int index) async {
    try {
      var response = await _serviceRepository.updateService(service);
      _servicesList[index] = service;
      _servicesLoadedSubject.add(_servicesList);
      _serviceUpdatedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  removeService(String serviceId, int index) async {
    try {
      var response = await _serviceRepository.deleteService(serviceId);
      _servicesList.removeAt(index);
      _servicesLoadedSubject.add(_servicesList);
      _serviceRemovedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
