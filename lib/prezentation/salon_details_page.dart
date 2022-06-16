import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SalonDetailsPage extends StatefulWidget {
  final Salon? salon;

  const SalonDetailsPage({Key? key, this.salon}) : super(key: key);

  @override
  State<SalonDetailsPage> createState() => _SalonDetailsPageState();
}

class _SalonDetailsPageState extends State<SalonDetailsPage> {

  @override
  void initState() {
    super.initState();

    print("Salon details init state");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Salon details",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
