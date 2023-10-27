import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.sectionName,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      decoration: BoxDecoration(
        color: Colors.cyan[100]!,
        border: Border.all(color: Colors.cyan[800]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //Section Name
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              //edit button
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.mode_edit_outline_outlined),
                color: Colors.grey[500],
              ),
            ],
          ),

          //text
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
