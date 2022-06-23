import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ProfileBloc {
  final GetSalonByIdUseCase _getSalonByIdUseCase;
  final UpdateSalonUseCase _updateSalonUseCase;
  final UpdateSalonPhotoUseCase _updateSalonPhotoUseCase;

  ProfileBloc(this._getSalonByIdUseCase, this._updateSalonUseCase, this._updateSalonPhotoUseCase);

  final _salonUpdatedSubject = PublishSubject<bool>();
  final _salonLoadedSubject = PublishSubject<Salon>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<bool> get salonUpdated => _salonUpdatedSubject.stream;

  Stream<Salon> get salonLoaded => _salonLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSalon(String id) async {
    var response = await _getSalonByIdUseCase(id);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonLoadedSubject.add(response.right);
    }
  }

  updateSalon(Salon salon, PickedFile? salonPhoto) async {
    if (salonPhoto != null) {
      var photoResponse = await _updateSalonPhotoUseCase(salonPhoto);
      if (photoResponse.isLeft) {
        _errorSubject.add(photoResponse.left.message);
      } else {
        salon.photo = photoResponse.right;
      }
    }
    var response = await _updateSalonUseCase(salon);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonUpdatedSubject.add(true);
    }
  }

  dispose() {}
}
