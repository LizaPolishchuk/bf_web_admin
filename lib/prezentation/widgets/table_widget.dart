import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_adminka/utils/mobile_table_widget.dart';
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
  bool _isDesktop = true;
  final double _rowHeight = 80;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        breakpoints: const ScreenBreakpoints(tablet: 400, desktop: 750, watch: 300),
        builder: (context, SizingInformation size) {
          if (size.isDesktop != _isDesktop) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _isDesktop = size.isDesktop;
              });
            });
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: _isDesktop ? 30 : 0, horizontal: _isDesktop ? 60 : 0),
            decoration: BoxDecoration(
              color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: ScreenTypeLayout.builder(
                breakpoints: const ScreenBreakpoints(tablet: 400, desktop: 750, watch: 300),
                mobile: (context) => MobileTableWidget(rows: _getTableRows(), columnTitles: widget.columnTitles),
                desktop: _buildTable,
                tablet: (context) => MobileTableWidget(rows: _getTableRows(), columnTitles: widget.columnTitles),
              ),
            ),
          );
        });
  }

  Widget _buildTable(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _getTableRows(),
      columnWidths: (widget.items.isNotEmpty && widget.items.first is FeedbackEntity)
          ? {
              0: const FlexColumnWidth(2),
              // 2: const FlexColumnWidth(1.5),
              3: const FlexColumnWidth(3),
              // 4: const FlexColumnWidth(0.5),
            }
          : {},
    );
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
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      isFirstColumn: true),
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
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: master.avatar,
                      isFirstColumn: true),
                  _buildRowText(master.phoneNumber ?? ""),
                  _buildRowText(master.services?.map((e) => e.name).toList().join(", ") ?? ""),
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

              // ClientStatus? clientStatus = client.status?.isNotEmpty == true
              //     ? ClientStatus.values.firstWhereOrNull((e) => e.name == client.status)
              //     : null;

              return MapEntry(
                index,
                _buildTableRow(index, [
                  _buildRowText(client.name,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: client.photoUrl,
                      isFirstColumn: true),
                  _buildRowText(client.city ?? ""),
                  // _buildRowText(clientStatus?.localizedName(context) ?? "", iconPath: clientStatus?.iconPath()),
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
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      photoUrl: feedback.authorAvatar,
                      isFirstColumn: true),
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
    var titleWidgets = widget.columnTitles
        .map(
          (title) => Container(
            height: _rowHeight,
            alignment: _isDesktop ? Alignment.center : Alignment.center,
            // padding: const EdgeInsets.only(bottom: 32),
            child: Text(title, style: Theme.of(context).textTheme.displaySmall),
          ),
        )
        .toList();

    return TableRow(children: titleWidgets);
  }

  Widget _buildRowText(String text,
      {TextStyle? style, int? categoryColor, String? photoUrl, String? iconPath, bool isFirstColumn = false}) {
    return SizedBox(
      height: _rowHeight,
      child: Row(
        mainAxisAlignment: isFirstColumn ? MainAxisAlignment.start : MainAxisAlignment.center,
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
                    return Container(color: Theme.of(context).colorScheme.primary);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Theme.of(context).colorScheme.primary);
                  },
                ),
              ),
            ),
          if (categoryColor != null) ColoredCircle(color: Color(categoryColor)),
          Flexible(
            child: Text(
              text,
              style: style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BaseEntity item, int index, {bool isOnlyView = false}) {
    final padding = EdgeInsets.only(left: _isDesktop ? 16 : 6);

    return SizedBox(
      height: _rowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (widget.onClickLook != null) {
                widget.onClickLook!(item, index);
              }
            },
            child: SvgPicture.asset(
              AppIcons.icEye,
              color: AppTheme.isDark ? Colors.white : AppColors.textColor,
            ),
          ),
          if (!isOnlyView)
            Padding(
              padding: padding,
              child: InkWell(
                onTap: () {
                  if (widget.onClickEdit != null) {
                    widget.onClickEdit!(item, index);
                  }
                },
                child: SvgPicture.asset(
                  AppIcons.icEdit,
                  color: AppTheme.isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            ),
          if (!isOnlyView)
            Padding(
              padding: padding,
              child: InkWell(
                onTap: () {
                  if (widget.onClickDelete != null) {
                    widget.onClickDelete!(item, index);
                  }
                },
                child: SvgPicture.asset(
                  AppIcons.icDelete,
                  color: AppTheme.isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildPointStars(int points) {
    return SizedBox(
      height: _rowHeight,
      child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.filled(
                5,
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: SvgPicture.asset(AppIcons.icStar),
                )),
            // itemBuilder: (context, index) {
            //   return SvgPicture.asset(AppIcons.icStar);
            // },
            // itemCount: points,
            // separatorBuilder: (BuildContext context, int index) {
            //   return const SizedBox(width: 5);
            // },
          )),
    );
  }
}
