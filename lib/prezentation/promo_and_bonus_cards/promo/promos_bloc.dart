import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class PromosBloc {
  final PromoRepository _promoRepository;

  PromosBloc(this._promoRepository);

  final _promosLoadedSubject = PublishSubject<List<Promo>>();
  final _promoAddedSubject = PublishSubject<bool>();
  final _promoUpdatedSubject = PublishSubject<bool>();
  final _promoRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  List<Promo> _promoList = [];

  // output stream
  Stream<List<Promo>> get promosLoaded => _promosLoadedSubject.stream;

  Stream<bool> get promoAdded => _promoAddedSubject.stream;

  Stream<bool> get promoUpdated => _promoUpdatedSubject.stream;

  Stream<bool> get promoRemoved => _promoRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getPromos(String salonId, PromoType promoType) async {
    try {
      var response = await _promoRepository.getSalonPromos(salonId);
      _promoList = response;
      _promosLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
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

  addPromo(Promo promo, [PickedFile? promoPhoto]) async {
    try {
      var response = await _promoRepository.createPromo(promo);
      _promoList.add(promo);
      _promosLoadedSubject.add(_promoList);
      _promoAddedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }

    // if (promoPhoto != null) {
    //   var photoResponse = await _updatePromoPhotoUseCase(promo.id, promoPhoto);
    //   if (photoResponse.isLeft) {
    //     _errorSubject.add(photoResponse.left.message);
    //   } else {
    //     promo.photoUrl = photoResponse.right;
    //   }
    // }
    // var response = await _addPromoUseCase(promo);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promoList.add(response.right);
    //   _promosLoadedSubject.add(_promoList);
    //   _promoAddedSubject.add(true);
    // }
  }

  updatePromo(Promo promo, int index, [PickedFile? promoPhoto]) async {
    try {
      var response = await _promoRepository.updatePromo(promo);
      _promoList[index] = promo;
      _promosLoadedSubject.add(_promoList);
      _promoUpdatedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
    // if (promoPhoto != null) {
    //   var photoResponse = await _updatePromoPhotoUseCase(promo.id, promoPhoto);
    //   if (photoResponse.isLeft) {
    //     _errorSubject.add(photoResponse.left.message);
    //   } else {
    //     promo.photoUrl = photoResponse.right;
    //   }
    // }
    // var response = await _updatePromoUseCase(promo);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promoList[index] = response.right;
    //   _promosLoadedSubject.add(_promoList);
    //   _promoUpdatedSubject.add(true);
    // }
  }

  removePromo(String promoId, int index) async {
    try {
      var response = await _promoRepository.deletePromo(promoId);
      _promoList.removeAt(index);
      _promosLoadedSubject.add(_promoList);
      _promoUpdatedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
