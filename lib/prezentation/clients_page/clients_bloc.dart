// import 'dart:async';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:bf_network_module/bf_network_module.dart';
//
// class ClientsBloc {
//   final GetClientListUseCase _getClientsListUseCase;
//   final AddClientUseCase _addClientUseCase;
//   final UpdateClientUseCase _updateClientUseCase;
//   final RemoveClientUseCase _removeClientUseCase;
//   final UpdateClientPhotoUseCase _updateClientPhotoUseCase;
//
//   ClientsBloc(this._getClientsListUseCase, this._addClientUseCase, this._updateClientUseCase, this._removeClientUseCase,
//       this._updateClientPhotoUseCase);
//
//   List<Client> _clientsList = [];
//
//   final _clientsLoadedSubject = PublishSubject<List<Client>>();
//   final _clientAddedSubject = PublishSubject<bool>();
//   final _clientUpdatedSubject = PublishSubject<bool>();
//   final _clientRemovedSubject = PublishSubject<bool>();
//   final _errorSubject = PublishSubject<String>();
//   final _isLoadingSubject = PublishSubject<bool>();
//
//   // output stream
//   Stream<List<Client>> get clientsLoaded => _clientsLoadedSubject.stream;
//
//   Stream<bool> get clientAdded => _clientAddedSubject.stream;
//
//   Stream<bool> get clientUpdated => _clientUpdatedSubject.stream;
//
//   Stream<bool> get clientRemoved => _clientRemovedSubject.stream;
//
//   Stream<String> get errorMessage => _errorSubject.stream;
//
//   Stream<bool> get isLoading => _isLoadingSubject.stream;
//
//   getClients(String salonId, String? categoryId) async {
//     var response = await _getClientsListUseCase(salonId);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _clientsList = response.right;
//       _clientsLoadedSubject.add(_clientsList);
//     }
//   }
//
//   searchClients(String searchKey) async {
//     print("searchClients: $searchKey");
//
//     if (searchKey.isEmpty) {
//       _clientsLoadedSubject.add(_clientsList);
//     }
//
//     List<Client> searchedList = [];
//     for (var client in _clientsList) {
//       if (client.name.toLowerCase().contains(searchKey.toLowerCase())) {
//         searchedList.add(client);
//       }
//     }
//
//     _clientsLoadedSubject.add(searchedList);
//   }
//
//   addClient(Client client, PickedFile? clientPhoto) async {
//     if (clientPhoto != null) {
//       var photoResponse = await _updateClientPhotoUseCase(client.id, clientPhoto);
//       if (photoResponse.isLeft) {
//         _errorSubject.add(photoResponse.left.message);
//       } else {
//         client.photoUrl = photoResponse.right;
//       }
//     }
//     var response = await _addClientUseCase(client);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _clientsList.add(response.right);
//       _clientsLoadedSubject.add(_clientsList);
//       _clientAddedSubject.add(true);
//     }
//   }
//
//   updateClient(Client client, int index, PickedFile? clientPhoto) async {
//     if (clientPhoto != null) {
//       var photoResponse = await _updateClientPhotoUseCase(client.id, clientPhoto);
//       if (photoResponse.isLeft) {
//         _errorSubject.add(photoResponse.left.message);
//       } else {
//         client.photoUrl = photoResponse.right;
//       }
//     }
//     var response = await _updateClientUseCase(client);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _clientsList[index] = response.right;
//       _clientsLoadedSubject.add(_clientsList);
//       _clientUpdatedSubject.add(true);
//     }
//   }
//
//   removeClient(String clientId, int index) async {
//     var response = await _removeClientUseCase(clientId);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _clientsList.removeAt(index);
//       _clientsLoadedSubject.add(_clientsList);
//       _clientRemovedSubject.add(true);
//     }
//   }
//
//   void refreshActualData() {
//     print("refreshActualData");
//     _clientsLoadedSubject.add(_clientsList);
//   }
//
//   dispose() {}
// }
