import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ClientsPage extends StatefulWidget {
  final Salon? salon;

  const ClientsPage({Key? key, this.salon}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Clients Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
