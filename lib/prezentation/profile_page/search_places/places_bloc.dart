import 'dart:async';

import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PlacesBloc {
  final GooglePlacesRepository _googlePlacesRepository;

  PlacesBloc(this._googlePlacesRepository);

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
    try {
      var response = await _googlePlacesRepository.fetchPlaceSuggestions(input, locale);
      _suggestedPlacesFoundSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  getPlaceDetails(String placeId) async {
    try {
      var response = await _googlePlacesRepository.getPlaceDetailFromId(placeId);
      _placeDetailsLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
