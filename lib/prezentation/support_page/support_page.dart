import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  final Salon? salon;

  const SupportPage({Key? key, this.salon}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Support Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
