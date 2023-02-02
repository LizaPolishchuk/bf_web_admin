import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PlacesBloc {
  final SearchPlacesUseCase _searchPlacesUseCase;
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;

  PlacesBloc(this._searchPlacesUseCase, this._getPlaceDetailsUseCase);

  final _suggestedPlacesFoundSubject = PublishSubject<List<SuggestionPlace>>();
  final _placeDetailsLoadedSubject = PublishSubject<Place>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<SuggestionPlace>> get suggestedPlacesFound => _suggestedPlacesFoundSubject.stream;

  Stream<Place> get placeDetailsLoaded => _placeDetailsLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  searchPlaces(String input, String locale) async {
    var response = await _searchPlacesUseCase(input, locale);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _suggestedPlacesFoundSubject.add(response.right);
    }
  }

  getPlaceDetails(String placeId) async {
    var response = await _getPlaceDetailsUseCase(placeId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _placeDetailsLoadedSubject.add(response.right);
    }
  }

  dispose() {}
}
