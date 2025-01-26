import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WithdrawalRequest extends StatefulWidget {
  const WithdrawalRequest({super.key});

  @override
  State<WithdrawalRequest> createState() => _WithdrawalRequestState();
}

class _WithdrawalRequestState extends State<WithdrawalRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.white),
              height: 90,
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 3,
                    ),
                    child: Text('Name:'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 3,
                    ),
                    child: Text('Phone Number:'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text('Amount:'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
