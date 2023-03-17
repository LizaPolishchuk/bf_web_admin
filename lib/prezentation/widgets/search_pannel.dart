import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_text_style.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';

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
        style: AppTextStyle.bodyMediumText,
        decoration: InputDecoration(
          counterText: "",
          isDense: true,
          fillColor: AppTheme.isDark ? Colors.white : null,
          hintText: widget.hintText,
          prefixIcon: const Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(
                Icons.search,
                color: AppColors.textColor,
              )),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }
}
