import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesPage extends StatefulWidget {
  final Salon? salon;

  const ServicesPage({Key? key, this.salon}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Services Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
