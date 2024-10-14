import 'package:flutter/material.dart';
import 'package:spaceships/colorcode.dart';

class  Agentcorner extends StatefulWidget {
  const Agentcorner({super.key});

  @override
  State<Agentcorner> createState() => _AgentcornerState();
}

class _AgentcornerState extends State< Agentcorner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
    child: Container(
    decoration: BoxDecoration(
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.6),
    spreadRadius: 12,
    blurRadius: 8,
    offset: const Offset(0, 3), // changes position of shadow
    ),
    ],
    ),
    child: AppBar(
    backgroundColor: ColorUtils.primaryColor(),
    iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Agentcorner"),
      ),
    ),
      ),
    );
  }
}
