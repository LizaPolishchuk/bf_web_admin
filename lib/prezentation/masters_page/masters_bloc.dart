import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class MastersBloc {
  final GetMastersListUseCase _getMastersListUseCase;
  final AddMasterUseCase _addMasterUseCase;
  final UpdateMasterUseCase _updateMasterUseCase;
  final RemoveMasterUseCase _removeMasterUseCase;

  MastersBloc(
    this._getMastersListUseCase,
    this._addMasterUseCase,
    this._updateMasterUseCase,
    this._removeMasterUseCase,
  );

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
    var response = await _getMastersListUseCase(salonId, categoryId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _mastersList = response.right;
      _mastersLoadedSubject.add(_mastersList);
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
    var response = await _addMasterUseCase(master);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _mastersList.add(response.right);
      _mastersLoadedSubject.add(_mastersList);
      _masterAddedSubject.add(true);
    }
  }

  updateMaster(Master master, int index) async {
    var response = await _updateMasterUseCase(master);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _mastersList[index] = response.right;
      _mastersLoadedSubject.add(_mastersList);
      _masterUpdatedSubject.add(true);
    }
  }

  removeMaster(String masterId, int index) async {
    var response = await _removeMasterUseCase(masterId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _mastersList.removeAt(index);
      _mastersLoadedSubject.add(_mastersList);
      _masterRemovedSubject.add(true);
    }
  }

  dispose() {}
}
