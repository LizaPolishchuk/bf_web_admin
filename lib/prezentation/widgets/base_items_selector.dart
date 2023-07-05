import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/widgets/colored_circle.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            bottom: BorderSide(
                color: _selectedItem == item
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.hintColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item != null && item is Category)
              ColoredCircle(color: item.color != null ? Color(item.color!) : Colors.grey),
            Text(
              item != null ? (item as Category).name : AppLocalizations.of(context)!.allServices,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: _selectedItem == item
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
