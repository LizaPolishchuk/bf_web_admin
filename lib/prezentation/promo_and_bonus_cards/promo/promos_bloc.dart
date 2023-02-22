import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromosBloc {
  final GetPromoListUseCase _getPromoListUseCase;
  final AddPromoUseCase _addPromoUseCase;
  final UpdatePromoUseCase _updatePromoUseCase;
  final RemovePromoUseCase _removePromoUseCase;
  final UpdatePromoPhotoUseCase _updatePromoPhotoUseCase;

  PromosBloc(this._getPromoListUseCase, this._addPromoUseCase, this._updatePromoUseCase, this._removePromoUseCase,
      this._updatePromoPhotoUseCase);

  List<Promo> _promoList = [];

  final _promosLoadedSubject = PublishSubject<List<Promo>>();
  final _promoAddedSubject = PublishSubject<bool>();
  final _promoUpdatedSubject = PublishSubject<bool>();
  final _promoRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<Promo>> get promosLoaded => _promosLoadedSubject.stream;

  Stream<bool> get promoAdded => _promoAddedSubject.stream;

  Stream<bool> get promoUpdated => _promoUpdatedSubject.stream;

  Stream<bool> get promoRemoved => _promoRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getPromos(String salonId) async {
    var response = await _getPromoListUseCase(salonId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _promoList = response.right;
      _promosLoadedSubject.add(_promoList);
    }
  }

  searchPromos(String searchKey) async {
    print("searchPromos: $searchKey");

    if (searchKey.isEmpty) {
      _promosLoadedSubject.add(_promoList);
    }

    List<Promo> searchedList = [];
    for (var promo in _promoList) {
      if (promo.name.toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(promo);
      }
    }

    _promosLoadedSubject.add(searchedList);
  }

  addPromo(Promo promo, PickedFile? promoPhoto) async {
    if (promoPhoto != null) {
      var photoResponse = await _updatePromoPhotoUseCase(promo.id, promoPhoto);
      if (photoResponse.isLeft) {
        _errorSubject.add(photoResponse.left.message);
      } else {
        promo.photoUrl = photoResponse.right;
      }
    }
    var response = await _addPromoUseCase(promo);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _promoList.add(response.right);
      _promosLoadedSubject.add(_promoList);
      _promoAddedSubject.add(true);
    }
  }

  updatePromo(Promo promo, int index, PickedFile? promoPhoto) async {
    if (promoPhoto != null) {
      var photoResponse = await _updatePromoPhotoUseCase(promo.id, promoPhoto);
      if (photoResponse.isLeft) {
        _errorSubject.add(photoResponse.left.message);
      } else {
        promo.photoUrl = photoResponse.right;
      }
    }
    var response = await _updatePromoUseCase(promo);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _promoList[index] = response.right;
      _promosLoadedSubject.add(_promoList);
      _promoUpdatedSubject.add(true);
    }
  }

  removePromo(String promoId, int index) async {
    var response = await _removePromoUseCase(promoId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _promoList.removeAt(index);
      _promosLoadedSubject.add(_promoList);
      _promoRemovedSubject.add(true);
    }
  }

  dispose() {}
}
