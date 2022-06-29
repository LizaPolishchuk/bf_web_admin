import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class TableWidget extends StatefulWidget {
  final List<BaseEntity> items;
  final List<String> columnTitles;

  // final Function(String) onClickDelete;
  // final Function(String) onClickDelete;

  const TableWidget({Key? key, required this.items, required this.columnTitles}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: const EdgeInsets.only(right: 38),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _getTableRows(),
        ));
  }

  List<TableRow> _getTableRows() {
    List<TableRow> tableRows = [];
    if (widget.items.isNotEmpty) {
      if (widget.items.first is Service) {
        tableRows = widget.items
            .asMap()
            .map((index, item) {
              var service = item as Service;
              return MapEntry(
                index,
                _buildTableRow(index, [
                  _buildRowText(service.name,
                      style: AppTextStyle.bodyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                  _buildRowText(service.price.toString()),
                  _buildRowText((service.duration ?? 0).toString()),
                  _buildRowText(service.categoryName ?? "", categoryColor: service.categoryColor),
                  _buildActions(),
                ]),
              );
            })
            .values
            .toList();
      }
    }

    tableRows.insert(0, _buildHeader());
    return tableRows;
  }

  TableRow _buildTableRow(int index, List<Widget> children) {
    return TableRow(
        decoration: index == widget.items.length - 1
            ? null
            : const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.hintColor, width: 0.5),
                ),
              ),
        children: children);
  }

  TableRow _buildHeader() {
    var titleWidgets = widget.columnTitles.map((e) => _buildTitle(e)).toList();

    return TableRow(children: titleWidgets);
  }

  Widget _buildRowText(String text, {TextStyle? style, int? categoryColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (categoryColor != null) ColoredCircle(color: Color(categoryColor)),
          Text(
            text,
            style: style ?? AppTextStyle.bodyText.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: SvgPicture.asset(AppIcons.icEye),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {},
          child: SvgPicture.asset(AppIcons.icEdit),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {},
          child: SvgPicture.asset(AppIcons.icDelete),
        )
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Text(
        title,
        style: AppTextStyle.hintText,
      ),
    );
  }
}
