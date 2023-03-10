import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class FeedbacksBloc {
  // final GetFeedbackListUseCase _getFeedbackListUseCase;
  // final AddFeedbackUseCase _addFeedbackUseCase;
  // final UpdateFeedbackUseCase _updateFeedbackUseCase;
  // final RemoveFeedbackUseCase _removeFeedbackUseCase;
  // final UpdateFeedbackPhotoUseCase _updateFeedbackPhotoUseCase;

  FeedbacksBloc();

  //this._getFeedbackListUseCase, this._addFeedbackUseCase, this._updateFeedbackUseCase, this._removeFeedbackUseCase, this._updateFeedbackPhotoUseCase);

  List<FeedbackEntity> feedbacksList = [
    FeedbackEntity(
        authorName: "Liza Polishchuk",
        feedbackText: "Nice salon!",
        date: DateTime(2023, 3, 23).millisecondsSinceEpoch,
        points: 5)
  ];

  final _feedbacksLoadedSubject = PublishSubject<List<FeedbackEntity>>();
  final _feedbackAddedSubject = PublishSubject<bool>();
  final _feedbackUpdatedSubject = PublishSubject<bool>();
  final _feedbackRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<FeedbackEntity>> get feedbacksLoaded => _feedbacksLoadedSubject.stream;

  Stream<bool> get feedbackAdded => _feedbackAddedSubject.stream;

  Stream<bool> get feedbackUpdated => _feedbackUpdatedSubject.stream;

  Stream<bool> get feedbackRemoved => _feedbackRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getFeedbacks(String salonId) async {
    await Future.delayed(Duration(seconds: 1));

    _feedbacksLoadedSubject.add(feedbacksList);

    // var response = await _getFeedbackListUseCase(salonId);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _feedbackList = response.right;
    //   _feedbacksLoadedSubject.add(_feedbackList);
    // }
  }

  searchFeedbacks(String searchKey) async {
    print("searchFeedbacks: $searchKey");

    if (searchKey.isEmpty) {
      _feedbacksLoadedSubject.add(feedbacksList);
    }

    List<FeedbackEntity> searchedList = [];
    for (var feedback in feedbacksList) {
      if (feedback.feedbackText.toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(feedback);
      }
    }

    _feedbacksLoadedSubject.add(searchedList);
  }

  addFeedback(FeedbackEntity feedback, PickedFile? feedbackPhoto) async {
    // if (feedbackPhoto != null) {
    //   var photoResponse = await _updateFeedbackPhotoUseCase(feedback.id, feedbackPhoto);
    //   if (photoResponse.isLeft) {
    //     _errorSubject.add(photoResponse.left.message);
    //   } else {
    //     feedback.photoUrl = photoResponse.right;
    //   }
    // }
    // var response = await _addFeedbackUseCase(feedback);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _feedbackList.add(response.right);
    //   _feedbacksLoadedSubject.add(_feedbackList);
    //   _feedbackAddedSubject.add(true);
    // }
  }

  updateFeedback(FeedbackEntity feedback, int index, PickedFile? feedbackPhoto) async {
    // if (feedbackPhoto != null) {
    //   var photoResponse = await _updateFeedbackPhotoUseCase(feedback.id, feedbackPhoto);
    //   if (photoResponse.isLeft) {
    //     _errorSubject.add(photoResponse.left.message);
    //   } else {
    //     feedback.photoUrl = photoResponse.right;
    //   }
    // }
    // var response = await _updateFeedbackUseCase(feedback);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _feedbackList[index] = response.right;
    //   _feedbacksLoadedSubject.add(_feedbackList);
    //   _feedbackUpdatedSubject.add(true);
    // }
  }

  removeFeedback(String feedbackId, int index) async {
    // var response = await _removeFeedbackUseCase(feedbackId);
    // if (response.isLeft) {
    //   _errorSubject.add(response.left.message);
    // } else {
    //   _feedbackList.removeAt(index);
    //   _feedbacksLoadedSubject.add(_feedbackList);
    //   _feedbackRemovedSubject.add(true);
    // }
  }

  dispose() {}
}
