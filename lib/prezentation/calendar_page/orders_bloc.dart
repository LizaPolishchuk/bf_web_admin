import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class OrdersBloc {
  final GetOrdersListUseCase _getOrdersListUseCase;
  final AddOrderUseCase _addOrderUseCase;
  final UpdateOrderUseCase _updateOrderUseCase;
  final RemoveOrderUseCase _removeOrderUseCase;

  OrdersBloc(this._getOrdersListUseCase, this._addOrderUseCase, this._updateOrderUseCase, this._removeOrderUseCase);

  List<OrderEntity> _ordersList = [];

  final _ordersLoadedSubject = PublishSubject<List<OrderEntity>>();
  final _orderAddedSubject = PublishSubject<bool>();
  final _orderUpdatedSubject = PublishSubject<bool>();
  final _orderRemovedSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<OrderEntity>> get ordersLoaded => _ordersLoadedSubject.stream;

  Stream<bool> get orderAdded => _orderAddedSubject.stream;

  Stream<bool> get orderUpdated => _orderUpdatedSubject.stream;

  Stream<bool> get orderRemoved => _orderRemovedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getOrders(String salonId) async {
    var response = await _getOrdersListUseCase(salonId, OrderForType.SALON);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList = response.right;
      _ordersLoadedSubject.add(_ordersList);
    }
  }

  addOrder(OrderEntity order) async {
    var response = await _addOrderUseCase(order);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList.add(response.right);
      _ordersLoadedSubject.add(_ordersList);
      _orderAddedSubject.add(true);
    }
  }

  updateOrder(OrderEntity orderEntity) async {
    var response = await _updateOrderUseCase(orderEntity);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList[_ordersList.indexOf(orderEntity)] = response.right;
      _ordersLoadedSubject.add(_ordersList);
      _orderUpdatedSubject.add(true);
    }
  }

  removeOrder(String orderId) async {
    var response = await _removeOrderUseCase(orderId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList.removeWhere((element) => element.id == orderId);
      _ordersLoadedSubject.add(_ordersList);
      _orderRemovedSubject.add(true);
    }
  }
}
