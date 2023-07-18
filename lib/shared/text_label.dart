import 'package:flutter/material.dart';

class TextLAbel extends StatelessWidget {
  final String texto;
  const TextLAbel({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(texto,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
    );
  }
}
