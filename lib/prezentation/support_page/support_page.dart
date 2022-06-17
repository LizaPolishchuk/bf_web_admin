import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

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
