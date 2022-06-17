import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ProfilePage extends StatefulWidget {
  final Salon? salon;

  const ProfilePage({Key? key, this.salon}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
