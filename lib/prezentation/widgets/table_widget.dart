import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/prezentation/clients_page/clients_page.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class TableWidget extends StatefulWidget {
  final List<BaseEntity> items;
  final List<String> columnTitles;
  final Function(BaseEntity item, int index)? onClickLook;
  final Function(BaseEntity item, int index)? onClickEdit;
  final Function(BaseEntity item, int index)? onClickDelete;

  // final Function(String) onClickDelete;

  const TableWidget(
      {Key? key,
      required this.items,
      required this.columnTitles,
      this.onClickLook,
      this.onClickEdit,
      this.onClickDelete})
      : super(key: key);

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
        child: SingleChildScrollView(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _getTableRows(),
            columnWidths: (widget.items.isNotEmpty && widget.items.first is FeedbackEntity)
                ? {
                    0: const FlexColumnWidth(2),
                    3: const FlexColumnWidth(4),
                  }
                : {},
          ),
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
                  _buildActions(item, index),
                ]),
              );
            })
            .values
            .toList();
      } else if (widget.items.first is Master) {
        tableRows = widget.items
            .asMap()
            .map((index, item) {
              var master = item as Master;
              return MapEntry(
                index,
                _buildTableRow(index, [
                  _buildRowText(master.name,
                      style: AppTextStyle.bodyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: master.avatar),
                  _buildRowText(master.phoneNumber ?? ""),
                  _buildRowText(master.providedServices?.values.join(", ") ?? ""),
                  _buildRowText(master.status ?? ""),
                  _buildActions(item, index),
                ]),
              );
            })
            .values
            .toList();
      } else if (widget.items.first is Client) {
        tableRows = widget.items
            .asMap()
            .map((index, item) {
              var client = item as Client;

              ClientStatus? clientStatus = client.status?.isNotEmpty == true
                  ? ClientStatus.values.firstWhereOrNull((e) => e.name == client.status)
                  : null;

              return MapEntry(
                index,
                _buildTableRow(index, [
                  _buildRowText(client.name,
                      style: AppTextStyle.bodyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: client.photoUrl),
                  _buildRowText(client.city ?? ""),
                  _buildRowText(clientStatus?.localizedName() ?? "", iconPath: clientStatus?.iconPath()),
                  _buildRowText(client.services?.values.join(", ") ?? ""),
                  _buildActions(item, index),
                ]),
              );
            })
            .values
            .toList();
      } else if (widget.items.first is FeedbackEntity) {
        tableRows = widget.items
            .asMap()
            .map((index, item) {
              var feedback = item as FeedbackEntity;

              return MapEntry(
                index,
                _buildTableRow(index, [
                  _buildRowText(feedback.authorName,
                      style: AppTextStyle.bodyText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: feedback.authorAvatar),
                  _buildRowText(DateFormat("dd.MM.yyyy").format(feedback.date)),
                  _buildPointStars(feedback.points),
                  _buildRowText(feedback.feedbackText),
                  _buildActions(item, index, isOnlyView: true),
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

  Widget _buildRowText(String text, {TextStyle? style, int? categoryColor, String? photoUrl, String? iconPath}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (iconPath?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SvgPicture.asset(iconPath!),
            ),
          if (photoUrl != null)
            Container(
              height: 35,
              width: 35,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  photoUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(color: AppColors.rose);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppColors.rose);
                  },
                ),
              ),
            ),
          if (categoryColor != null) ColoredCircle(color: Color(categoryColor)),
          Flexible(
            child: Text(
              text,
              style: style ?? AppTextStyle.bodyText.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BaseEntity item, int index, {bool isOnlyView = false}) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (widget.onClickLook != null) {
              widget.onClickLook!(item, index);
            }
          },
          child: SvgPicture.asset(AppIcons.icEye),
        ),
        if (!isOnlyView)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                if (widget.onClickEdit != null) {
                  widget.onClickEdit!(item, index);
                }
              },
              child: SvgPicture.asset(AppIcons.icEdit),
            ),
          ),
        if (!isOnlyView)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                if (widget.onClickDelete != null) {
                  widget.onClickDelete!(item, index);
                }
              },
              child: SvgPicture.asset(AppIcons.icDelete),
            ),
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

  Widget _buildPointStars(int points) {
    return SizedBox(
        height: 16,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SvgPicture.asset(AppIcons.icStar);
          },
          itemCount: points,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 5);
          },
        ));
  }
}
