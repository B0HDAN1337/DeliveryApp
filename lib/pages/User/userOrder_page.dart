import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/service/User/userOrderService.dart';
import 'package:flutter/material.dart';

class UserOrderPage extends StatefulWidget {
  const UserOrderPage({super.key});

  @override
  State<UserOrderPage> createState() => _ClientOrdersPageState();
}

class _ClientOrdersPageState extends State<UserOrderPage> {
  final _service = UserOrderService();
  late Future<List<Order>> _orders;
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orders = _service.getMyOrders();
  }

  Future<void> _refresh() async {
    setState(() {
      _orders = _service.getMyOrders();
    });
  }

  Future<void> _createOrder() async {
    final pickup = _pickupController.text;
    final dropoff = _dropoffController.text;
    if (pickup.isEmpty || dropoff.isEmpty) return;

    await _service.createOrder(pickup, dropoff);
    _pickupController.clear();
    _dropoffController.clear();
    _refresh();
  }

  Future<void> _cancelOrder(int id) async {
    await _service.cancelOrder(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Order>>(
          future: _orders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Create new order', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _pickupController,
                          decoration: const InputDecoration(
                            labelText: 'Where pick the parcel',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _dropoffController,
                          decoration: const InputDecoration(
                            labelText: 'Where to deliver',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Create'),
                          onPressed: _createOrder,
                        )
                      ],
                    ),
                  ),
                ),

                ...orders.map((o) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('ID: ${o.id} | ${o.deliveryStatus}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From: ${o.pickupLocation}'),
                            Text('To: ${o.dropoffLocation}'),
                          ],
                        ),
                        trailing: o.deliveryStatus == 'pending'
                            ? IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _cancelOrder(o.id),
                              )
                            : null,
                      ),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
