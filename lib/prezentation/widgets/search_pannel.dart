import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_text_style.dart';

class SearchPanel extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;

  const SearchPanel({Key? key, required this.hintText, required this.onSearch}) : super(key: key);

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      widget.onSearch(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: TextField(
        controller: _searchController,
        style: AppTextStyle.bodyText,
        decoration: InputDecoration(
          counterText: "",
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: AppTextStyle.hintText,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: widget.hintText,
          prefixIcon: const Align(widthFactor: 1.0, heightFactor: 1.0, child: Icon(Icons.search)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }
}
