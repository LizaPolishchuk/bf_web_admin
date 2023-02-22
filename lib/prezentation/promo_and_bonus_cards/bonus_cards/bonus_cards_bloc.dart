import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class BonusCardsBloc {
  final GetBonusCardListUseCase _getBonusCardListUseCase;
  final AddBonusCardUseCase _addBonusCardUseCase;
  final UpdateBonusCardUseCase _updateBonusCardUseCase;
  final RemoveBonusCardUseCase _removeBonusCardUseCase;

  BonusCardsBloc(this._getBonusCardListUseCase, this._addBonusCardUseCase, this._updateBonusCardUseCase,
      this._removeBonusCardUseCase);

  List<BonusCard> _bonusCardsList = [];

  final _bonusCardsLoadedSubject = PublishSubject<List<BonusCard>>();
  final _bonusCardAddedSubject = PublishSubject<bool>();
  final _bonusCardUpdatedSubject = PublishSubject<bool>();
  final _bonusCardRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<BonusCard>> get bonusCardsLoaded => _bonusCardsLoadedSubject.stream;

  Stream<bool> get bonusCardAdded => _bonusCardAddedSubject.stream;

  Stream<bool> get bonusCardUpdated => _bonusCardUpdatedSubject.stream;

  Stream<bool> get bonusCardRemoved => _bonusCardRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getBonusCards(String salonId) async {
    var response = await _getBonusCardListUseCase(salonId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _bonusCardsList = response.right;
      print("getBonusCards: ${_bonusCardsList.length}");
      _bonusCardsLoadedSubject.add(_bonusCardsList);
    }
  }

  searchBonusCards(String searchKey) async {
    print("searchBonusCards: $searchKey");

    if (searchKey.isEmpty) {
      _bonusCardsLoadedSubject.add(_bonusCardsList);
    }

    List<BonusCard> searchedList = [];
    for (var bonusCard in _bonusCardsList) {
      if (bonusCard.name.toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(bonusCard);
      }
    }

    _bonusCardsLoadedSubject.add(searchedList);
  }

  addBonusCard(BonusCard bonusCard) async {
    var response = await _addBonusCardUseCase(bonusCard);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _bonusCardsList.add(response.right);
      _bonusCardsLoadedSubject.add(_bonusCardsList);
      _bonusCardAddedSubject.add(true);
    }
  }

  updateBonusCard(BonusCard bonusCard, int index) async {
    var response = await _updateBonusCardUseCase(bonusCard);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _bonusCardsList[index] = response.right;
      _bonusCardsLoadedSubject.add(_bonusCardsList);
      _bonusCardUpdatedSubject.add(true);
    }
  }

  removeBonusCard(String bonusCardId, int index) async {
    var response = await _removeBonusCardUseCase(bonusCardId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _bonusCardsList.removeAt(index);
      _bonusCardsLoadedSubject.add(_bonusCardsList);
      _bonusCardRemovedSubject.add(true);
    }
  }

  dispose() {}
}
