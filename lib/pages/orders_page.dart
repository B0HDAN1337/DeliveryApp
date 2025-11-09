import 'package:delivery_app/service/courierOrderService.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../service/courierOrderService.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _CourierOrdersPageState();
}

class _CourierOrdersPageState extends State<OrdersPage> {
  final CourierOrderService _service = CourierOrderService();
  List<Order> orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => loading = true);
    try {
      final fetchedOrders = await _service.fetchMyOrders();
      setState(() {
        orders = fetchedOrders;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch orders')),
      );
    }
  }

  Future<void> _acceptOrder(int orderId) async {
  try {
    await _service.acceptOrder(orderId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order accepted')),
    );
    _fetchOrders();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to accept order')),
    );
  }
}


  Future<void> _updateStatus(int orderId, String status) async {
    try {
      await _service.updateStatus(orderId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated')),
      );
      _fetchOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchOrders,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Order #${order.id}'),
                      subtitle: Text(
                        'Pickup: ${order.pickupLocation}\n'
                        'Dropoff: ${order.dropoffLocation}\n'
                        'Status: ${order.deliveryStatus}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'accept') {
                            _acceptOrder(order.id);
                          } else {
                            _updateStatus(order.id, value);
                          }
                        },
                        itemBuilder: (context) => [
                          if (order.deliveryStatus == 'pending')
                            const PopupMenuItem(
                              value: 'accept',
                              child: Text('Accept'),
                            ),
                          const PopupMenuItem(
                            value: 'in_progress',
                            child: Text('In Progress'),
                          ),
                          const PopupMenuItem(
                            value: 'delivered',
                            child: Text('Delivered'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
