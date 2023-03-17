import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class TemporaryPromoList extends StatelessWidget {
  final List<Promo> promoList;
  final Function(Promo, int) onClickMore;

  const TemporaryPromoList({Key? key, required this.promoList, required this.onClickMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: ScrollController(),
      itemBuilder: (context, index) {
        return _buildPromoItem(context, promoList[index], index);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20, width: double.infinity);
      },
      itemCount: promoList.length,
    );
  }

  Widget _buildPromoItem(BuildContext context, Promo promo, int index) {
    return Container(
      height: 220,
      width: 220,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: onClickMore(promo, index),
          ),
          SizedBox(
            width: 110,
            height: 110,
            child: Image.network(
              promo.photoUrl ?? "",
              errorBuilder: (context, obj, stackTrace) {
                return Container(
                  color: AppColors.lightRose,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            promo.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            promo.description ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
