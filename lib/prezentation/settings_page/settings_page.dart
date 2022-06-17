import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SettingsPage extends StatefulWidget {
  final Salon? salon;

  const SettingsPage({Key? key, this.salon}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Settings Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
