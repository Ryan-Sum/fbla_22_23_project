import 'package:fbla_22_23_project/themes/palette.dart';
import 'package:flutter/material.dart';

class EventCards extends StatefulWidget {
  final String title;
  final bool isActive;

  const EventCards({
    super.key,
    required this.title,
    required this.isActive,
  });

  @override
  State<EventCards> createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Center(
        child: Container(
          width: 350,
          height: 54,
          decoration: BoxDecoration(
              color: widget.isActive
                  ? Palette.primarySwatch
                  : const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Text(
              widget.title,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
    );
  }
}
