import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MobileTableWidget extends StatefulWidget {
  final List<TableRow> rows;
  final List<String> columnTitles;

  const MobileTableWidget({Key? key, required this.rows, required this.columnTitles}) : super(key: key);

  @override
  State<MobileTableWidget> createState() => _MobileTableWidgetState();
}

class _MobileTableWidgetState extends State<MobileTableWidget> {
  int _currentColumn = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: [
          _buildButtons(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getColumnItems(0),
                ),
              ),
              // Container(
              //   height: 80,
              //   width: 0.5,
              //   color: AppColors.hintColor,
              // ),
              // const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getColumnItems(_currentColumn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _getColumnItems(int column) {
    List<Widget> items = [];


    for (int i = 0; i < widget.rows.length; i++) {
      TableRow row = widget.rows[i];
      if ((row.children?.length ?? 0) > 0) {
        items.add(
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: i < widget.rows.length - 1
                    ? const BorderSide(color: AppColors.hintColor, width: 0.5)
                    : BorderSide.none,
                right: column == 0
                    ? const BorderSide(color: AppColors.hintColor, width: 0.5)
                    : BorderSide.none,
              ),
            ),
            child: row.children![column],
          ),
        );
      }
    }

    return items;
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (_currentColumn > 1) {
                setState(() {
                  _currentColumn -= 1;
                });
              }
            },
            icon: Icon(
              Icons.arrow_circle_left,
              color: Theme.of(context).colorScheme.primary,
            )),
        const SizedBox(width: 10),
        IconButton(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (_currentColumn < (widget.rows.first.children?.length ?? 0) - 1) {
                setState(() {
                  _currentColumn += 1;
                });
              }
            },
            icon: Icon(
              Icons.arrow_circle_right,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
    );
  }
}
