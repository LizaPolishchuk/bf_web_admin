import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final SalonRepository _salonRepository;
  final MediaRepository _mediaRepository;

  ProfileBloc(this._salonRepository, this._mediaRepository);

  final _salonUpdatedSubject = PublishSubject<bool>();
  final _salonLoadedSubject = PublishSubject<Salon>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get salonUpdated => _salonUpdatedSubject.stream;

  Stream<Salon> get salonLoaded => _salonLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSalon() async {
    try {
      var response = await _salonRepository.getSalon();
      _salonLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  updateSalon(Salon salon, PickedFile? salonPhoto) async {
    try {
      if (salonPhoto != null) {
        var photoResponse = await _mediaRepository.getSignedUrl(
          SignedUrlRequest(
            salon.id,
            PhotoType.salon,
          ),
        );

        print("signedUrl: ${photoResponse}");
      }

      var response = await _salonRepository.updateSalon(salon);
      _salonLoadedSubject.add(salon);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
