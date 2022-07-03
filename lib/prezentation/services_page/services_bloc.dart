import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesBloc {
  final GetServicesListUseCase _getServicesListUseCase;
  final AddServiceUseCase _addServiceUseCase;
  final UpdateServiceUseCase _updateServiceUseCase;
  final RemoveServiceUseCase _removeServiceUseCase;

  ServicesBloc(
      this._getServicesListUseCase, this._addServiceUseCase, this._updateServiceUseCase, this._removeServiceUseCase);

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
    var response = await _getServicesListUseCase(salonId, categoryId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _servicesList = response.right;
      _servicesLoadedSubject.add(_servicesList);
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
    var response = await _addServiceUseCase(service);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _servicesList.add(response.right);
      _servicesLoadedSubject.add(_servicesList);
      _serviceAddedSubject.add(true);
    }
  }

  updateService(Service service, int index) async {
    var response = await _updateServiceUseCase(service);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _servicesList[index] = response.right;
      _servicesLoadedSubject.add(_servicesList);
      _serviceUpdatedSubject.add(true);
    }
  }

  removeService(String serviceId, int index) async {
    var response = await _removeServiceUseCase(serviceId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _servicesList.removeAt(index);
      _servicesLoadedSubject.add(_servicesList);
      _serviceRemovedSubject.add(true);
    }
  }

  dispose() {}
}
