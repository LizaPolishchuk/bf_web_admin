import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromosPage extends StatefulWidget {
  final Salon? salon;

  const PromosPage({Key? key, this.salon}) : super(key: key);

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Promos Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
