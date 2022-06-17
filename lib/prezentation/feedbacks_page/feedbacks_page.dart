import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class FeedbacksPage extends StatefulWidget {
  final Salon? salon;

  const FeedbacksPage({Key? key, this.salon}) : super(key: key);

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          "Feedbacks Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
