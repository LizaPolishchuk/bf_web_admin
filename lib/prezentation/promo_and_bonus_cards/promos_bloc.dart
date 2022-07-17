import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromosBloc {
  // final GetPromosListUseCase _getPromosListUseCase;
  // final AddPromoUseCase _addPromoUseCase;
  // final UpdatePromoUseCase _updatePromoUseCase;
  // final RemovePromoUseCase _removePromoUseCase;

  PromosBloc(// this._getPromosListUseCase, this._addPromoUseCase, this._updatePromoUseCase, this._removePromoUseCase
      );

  List<Promo> _promoList = [
    Promo("id", "name", "description",
        "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg", DateTime(2022, 7, 22)),
    Promo("id", "name1", "description",
        "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg", DateTime(2022, 7, 22)),
    Promo("id", "name2", "description",
        "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg", DateTime(2022, 7, 22)),
    Promo("id", "name3", "description",
        "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg", DateTime(2022, 7, 22)),
    Promo("id", "name4", "description",
        "https://t4.ftcdn.net/jpg/02/43/87/41/360_F_243874126_YLSIGaDgoNzS91Xdbg1IVpiwXeeZSXdr.jpg", DateTime(2022, 7, 22)),
  ];

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
    await Future.delayed(Duration(seconds: 1));
    _promosLoadedSubject.add(_promoList);

    // var response = await _getPromosListUseCase(salonId, categoryId);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promosList = response.right;
    //   _promosLoadedSubject.add(_promosList);
    // }
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

  addPromo(Promo promo) async {
    // var response = await _addPromoUseCase(promo);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promosList.add(response.right);
    //   _promosLoadedSubject.add(_promosList);
    //   _promoAddedSubject.add(true);
    // }
  }

  updatePromo(Promo promo, int index) async {
    // var response = await _updatePromoUseCase(promo);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promosList[index] = response.right;
    //   _promosLoadedSubject.add(_promosList);
    //   _promoUpdatedSubject.add(true);
    // }
  }

  removePromo(String promoId, int index) async {
    // var response = await _removePromoUseCase(promoId);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _promosList.removeAt(index);
    //   _promosLoadedSubject.add(_promosList);
    //   _promoRemovedSubject.add(true);
    // }
  }

  dispose() {}
}
