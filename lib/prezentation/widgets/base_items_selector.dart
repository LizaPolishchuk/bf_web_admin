import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class BaseItemsSelector extends StatefulWidget {
  final List<BaseEntity> items;
  final Function(BaseEntity?) onSelectedItem;

  const BaseItemsSelector({Key? key, required this.onSelectedItem, required this.items}) : super(key: key);

  @override
  State<BaseItemsSelector> createState() => _BaseItemsSelectorState();
}

class _BaseItemsSelectorState extends State<BaseItemsSelector> {
  BaseEntity? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildItem(null);
          }
          return _buildItem(widget.items[index - 1]);
        },
        itemCount: widget.items.length + 1,
      ),
    );
  }

  Widget _buildItem(BaseEntity? item) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedItem = item;
        });

        widget.onSelectedItem(item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _selectedItem == item ? AppColors.darkRose : AppColors.hintColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item != null && item is Category)
              ColoredCircle(color: item.color != null ? Color(item.color!) : Colors.grey),
            Text(
              item != null ? item.name : AppLocalizations.of(context)!.allServices,
              style: AppTextStyle.hintText
                  .copyWith(color: _selectedItem == item ? AppColors.darkRose : AppColors.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
