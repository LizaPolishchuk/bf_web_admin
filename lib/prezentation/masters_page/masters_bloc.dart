import 'dart:async';

import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class MastersBloc {
  final MasterRepository _masterRepository;

  MastersBloc(this._masterRepository);

  List<Master> _mastersList = [];

  final _mastersLoadedSubject = PublishSubject<List<Master>>();
  final _masterAddedSubject = PublishSubject<bool>();
  final _masterUpdatedSubject = PublishSubject<bool>();
  final _masterRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<Master>> get mastersLoaded => _mastersLoadedSubject.stream;

  Stream<bool> get masterAdded => _masterAddedSubject.stream;

  Stream<bool> get masterUpdated => _masterUpdatedSubject.stream;

  Stream<bool> get masterRemoved => _masterRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getMasters(String salonId, String? categoryId) async {
    try {
      var response = await _masterRepository.getSalonMasters(salonId);
      _mastersList = response;
      _mastersLoadedSubject.add(_mastersList);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  searchMasters(String searchKey) async {
    if (searchKey.isEmpty) {
      _mastersLoadedSubject.add(_mastersList);
    }

    List<Master> searchedList = [];
    for (var master in _mastersList) {
      if (master.name.toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(master);
      }
    }

    _mastersLoadedSubject.add(searchedList);
  }

  addMaster(Master master) async {
    try {
      var response = await _masterRepository.createMaster(master);
      _mastersList.add(master);
      _mastersLoadedSubject.add(_mastersList);
      _masterAddedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  updateMaster(Master master, int index) async {
    try {
      var response = await _masterRepository.updateMaster(master);
      _mastersList[index] = master;
      _mastersLoadedSubject.add(_mastersList);
      _masterUpdatedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  removeMaster(String masterId, int index) async {
    try {
      var response = await _masterRepository.deleteMaster(masterId);
      _mastersList.removeAt(index);
      _mastersLoadedSubject.add(_mastersList);
      _masterRemovedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
