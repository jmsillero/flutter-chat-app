import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage(
      {super.key,
      required this.message,
      required this.uuid,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child:
              uuid == '123' ? _MyMessage(message) : _ExternalMessage(message),
        ),
      ),
    );
  }
}

class _ExternalMessage extends StatelessWidget {
  final String message;
  const _ExternalMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
        decoration: BoxDecoration(
            color: const Color(0xFFE4E5E8),
            borderRadius: BorderRadius.circular(20)),
        child: Text(message, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  final String message;
  const _MyMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: const Color(0xFF4D9EF6),
            borderRadius: BorderRadius.circular(20)),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
