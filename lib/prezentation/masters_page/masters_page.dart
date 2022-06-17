import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class MastersPage extends StatefulWidget {
  final Salon? salon;

  const MastersPage({Key? key, this.salon}) : super(key: key);

  @override
  State<MastersPage> createState() => _MastersPageState();
}

class _MastersPageState extends State<MastersPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Masters Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
