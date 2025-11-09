import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../service/orderService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/authService.dart';

class AvailableOrdersPage extends StatefulWidget {
  const AvailableOrdersPage({super.key});

  @override
  State<AvailableOrdersPage> createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersFuture;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderService.fetchAvailableOrders();
  }

  Future<void> _acceptOrder(Order order) async {
    setState(() {
      _loading = true;
    });

    final courierId = await _orderService.getUserId(); 
    final success = await _orderService.acceptOrder(order.id, int.parse(courierId));

    setState(() {
      _loading = false;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order #${order.id} accepted!')),
        );
        _ordersFuture = _orderService.fetchAvailableOrders();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept order')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Orders')),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No available orders'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text(
                      'Pickup: ${order.pickupLocation}\nDropoff: ${order.dropoffLocation}\nStatus: ${order.deliveryStatus}'),
                  trailing: _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _acceptOrder(order),
                          child: const Text('Accept'),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
