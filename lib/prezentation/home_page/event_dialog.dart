import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import '../../utils/app_colors.dart';

class EventAlertDialog extends StatelessWidget {
  const EventAlertDialog({
    Key? key,
    required this.order,
    required this.themeData,
    required this.close,
    required this.showMore,
  }) : super(key: key);

  final OrderEntity order;
  final ThemeData themeData;
  final String close;
  final String showMore;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightRose,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: order.masterAvatar ?? "",
              imageBuilder: (context, imageProvider) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 6),
                  child: Image(
                    image: imageProvider,
                    width: 30,
                    height: 30,
                  ),
                );
              },
              fit: BoxFit.scaleDown,
              errorWidget: (context, obj, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.serviceName,
                    style: TextStyle(
                        color: order.categoryColor != null ? Color(order.categoryColor!) : AppColors.darkRose,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    order.clientName ?? AppLocalizations.of(context)!.client,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${AppLocalizations.of(context)!.master}: ${order.masterName}",
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('HH:mm').format(order.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.hintColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(close.toUpperCase())),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(showMore.toUpperCase())),
      ],
    );
  }
}
