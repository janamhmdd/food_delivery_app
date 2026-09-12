import 'package:equatable/equatable.dart';
import '../domain/entities/order_record.dart';

enum OrdersStatus { loading, success }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderRecord> orders; // newest first

  const OrdersState({
    this.status = OrdersStatus.loading,
    this.orders = const [],
  });

  List<OrderRecord> get active =>
      orders.where((o) => o.status == OrderLocalStatus.active).toList();
  List<OrderRecord> get completed =>
      orders.where((o) => o.status == OrderLocalStatus.completed).toList();
  List<OrderRecord> get cancelled =>
      orders.where((o) => o.status == OrderLocalStatus.cancelled).toList();

  OrdersState copyWith({OrdersStatus? status, List<OrderRecord>? orders}) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [status, orders];
}