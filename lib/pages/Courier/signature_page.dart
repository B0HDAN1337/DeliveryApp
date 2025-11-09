import 'dart:io';
import 'dart:typed_data';
import 'package:delivery_app/service/SignatureService.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';


class SignaturePage extends StatefulWidget {
  final Function(Uint8List?) onSigned;
  final int orderId;

  const SignaturePage({super.key, required this.onSigned, required this.orderId});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 void _saveSignature() async {
  if (_controller.isNotEmpty) {
    final signatureData = await _controller.toPngBytes();
    if (signatureData != null) {
      final success = await SignatureService().uploadSignature(signatureData, widget.orderId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery confirmed with signature')),
        );
        widget.onSigned(signatureData); 
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload signature')),
        );
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please sign before confirming')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign to Confirm Delivery')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Please provide your signature below:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Signature(controller: _controller, backgroundColor: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () => _controller.clear(),
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
              ElevatedButton.icon(
                onPressed: _saveSignature,
                icon: const Icon(Icons.check),
                label: const Text('Confirm'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
