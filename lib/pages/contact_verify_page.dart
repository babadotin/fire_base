import 'package:flutter/material.dart';

class ContactVerifyPage extends StatelessWidget {
  final String contact;

  const ContactVerifyPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Contact'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification code has been sent to $contact.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your logic for verifying the contact here
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
