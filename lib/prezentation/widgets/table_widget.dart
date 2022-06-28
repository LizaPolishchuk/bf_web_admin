import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({Key? key}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  List<String> titles = ["Название услуги", "Цена, грн", "Мастера", "Время, мин", "Категория", "Действия"];
  List<Service> serviceList = [
    Service("id", "name", "description", 200, "creatorSalon", "categoryId", 60),
    Service("id", "name", "description", 200, "creatorSalon", "categoryId", 60)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          // border: const TableBorder(horizontalInside: BorderSide(color: AppColors.hintColor, width: 0.5)),
          children: _getTableRows(),
        ));
  }

  List<TableRow> _getTableRows() {
    List<TableRow> tableRows = serviceList
        .asMap()
        .map((index, service) {
          return MapEntry(
              index,
              TableRow(
                  decoration: index == serviceList.length - 1
                      ? null
                      : const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.hintColor, width: 0.5))),
                  children: [
                    _buildRowText(service.name,
                        style: AppTextStyle.bodyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                    _buildRowText(service.price.toString()),
                    _buildRowText("Татьяна Губань"),
                    _buildRowText(service.duration.toString()),
                    _buildRowText("Ногти", isCategory: true),
                    _buildActions(),
                  ]));
        })
        .values
        .toList();

    tableRows.insert(0, _buildHeader());
    return tableRows;
  }

  TableRow _buildHeader() {
    var titleWidgets = titles.map((e) => _buildTitle(e)).toList();

    return TableRow(children: titleWidgets);
  }

  Widget _buildRowText(String text, {TextStyle? style, bool? isCategory}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (isCategory == true) const ColoredCircle(color: Colors.red),
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
