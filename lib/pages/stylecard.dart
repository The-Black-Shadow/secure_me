import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:intl/intl.dart';

class StyledCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  const StyledCard({Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: $userEmail',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Wrap the AnalogClock in a Container with a fixed height
            Container(
              height: 200, // Adjust the height as needed
              child: AnalogClock(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                width: 100,
                isLive: true,
                showNumbers: false,
                showTicks: true,
                hourHandColor: Colors.black,
                minuteHandColor: Colors.black,
                secondHandColor: Colors.red,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
