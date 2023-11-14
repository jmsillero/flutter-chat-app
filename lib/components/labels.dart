import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String questionText;
  final String actionText;
  final String route;

  const Labels(
      {super.key,
      required this.questionText,
      required this.actionText,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          questionText,
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacementNamed(route),
          child: Text(
            actionText,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
