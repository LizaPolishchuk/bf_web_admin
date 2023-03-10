import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class BonusCardsList extends StatelessWidget {
  final List<Promo> bonusCardsList;
  final Function(Promo, int) onClickMore;

  const BonusCardsList({Key? key, required this.bonusCardsList, required this.onClickMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation size) {
        return GridView.count(
            scrollDirection: size.isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisCount: size.isMobile ? 1 : 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: size.isMobile ? 1.5 / 1 : 1 / 1.5,
            children: bonusCardsList
                .asMap()
                .map((index, item) => MapEntry(index, _buildBonusCardItem(context, item, index)))
                .values
                .toList());
      },
    );
  }

  Widget _buildBonusCardItem(BuildContext context, Promo bonusCard, int index) {
    return Container(
      height: 220,
      width: 340,
      padding: const EdgeInsets.only(left: 20, right: 10, top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bonusCard.color != null ? Color(bonusCard.color!) : AppColors.rose,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4C4C4).withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    bonusCard.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 6),
                onClickMore(bonusCard, index),
              ],
            ),
          ),
          Center(
            child: Text(
              "${bonusCard.discount}%",
              style: const TextStyle(color: Colors.white, fontSize: 48),
            ),
          ),
        ],
      ),
    );
  }
}
