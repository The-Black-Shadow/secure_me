import 'package:flutter/material.dart';

class SubsPlan extends StatelessWidget {
  final String planName;
  final void Function()? onTap;
  final String price;
  const SubsPlan(
      {super.key,
      required this.planName,
      required this.onTap,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 3.8), //(x,y)
            blurRadius: 9.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              title: Text(planName),
              subtitle: const Text('Yearly'),
              trailing: Text(price),
            ),
          ],
        ),
      ),
    );
  }
}
