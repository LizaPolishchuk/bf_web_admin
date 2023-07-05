import 'dart:async';

import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class CreateSalonBloc {
  final SalonRepository _salonRepository;
  final MediaRepository _mediaRepository;

  CreateSalonBloc(this._salonRepository, this._mediaRepository);

  final _salonCreatedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get salonCreated => _salonCreatedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  createSalon(Salon salon, PickedFile? salonPhoto) async {
    try {
      // var response = await _salonRepository.createSalon(salon);

      // print("salon uuid: ${response.uuid}");
      // Y_vRG0HoQr-EdVxBisUxmg

      if (salonPhoto != null) {
        var photoResponse = await _mediaRepository.getSignedUrl(
          SignedUrlRequest(
            "Y_vRG0HoQr-EdVxBisUxmg",  //response.uuid
            PhotoType.salon,
          ),
        );

        print("signedUrl: ${photoResponse}");
      }



      // _salonCreatedSubject.add(true);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  dispose() {}
}
