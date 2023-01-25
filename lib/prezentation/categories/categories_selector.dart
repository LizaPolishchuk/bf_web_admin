import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/categories/categories_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/base_items_selector.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CategoriesSelector extends StatefulWidget {
  final Function(List<Category>) onCategoriesLoaded;
  final Function(Category?) onSelectedCategory;
  final bool showAddButton;

  const CategoriesSelector(
      {Key? key, required this.onCategoriesLoaded, required this.onSelectedCategory, this.showAddButton = true})
      : super(key: key);

  @override
  State<CategoriesSelector> createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends State<CategoriesSelector> {
  late String _currentSalonId;

  late CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _categoriesBloc = getItWeb<CategoriesBloc>();
    _categoriesBloc.getCategories(_currentSalonId);

    _categoriesBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: StreamBuilder<List<Category>>(
              stream: _categoriesBloc.categoriesLoaded,
              builder: (context, snapshot) {
                if (snapshot.data?.isNotEmpty == true) {
                  widget.onCategoriesLoaded(snapshot.data!);
                }
                return BaseItemsSelector(
                  items: snapshot.data ?? [],
                  onSelectedItem: (item) {
                    widget.onSelectedCategory(item as Category);
                  },
                );
              }),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () {
            if (_categoriesBloc.categoriesList.length >= 20) {
              //todo show alert that max count of categories is 20
            } else {
              _showAddCategoryDialog();
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              "${AppLocalizations.of(context)!.add} +",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
      ],
      // ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          Color? selectedColor;
          final TextEditingController categoryNameController = TextEditingController();

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                height: 250.0,
                width: 400.0,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.hintColor,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.addNewCategory,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 21),
                    Flexible(
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.blurColor.withOpacity(0.25),
                                      blurRadius: 5,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  controller: categoryNameController,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.categoryName,
                                    counterText: "",
                                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blurColor.withOpacity(0.25),
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Color>(
                                  menuMaxHeight: 150,
                                  value: selectedColor,
                                  selectedItemBuilder: (context) {
                                    return Colors.primaries.map<Widget>((e) => const SizedBox.shrink()).toList();
                                  },
                                  icon: selectedColor != null
                                      ? ColoredCircle(height: 14, width: 14, color: selectedColor!)
                                      : const Icon(Icons.arrow_drop_down),
                                  alignment: Alignment.center,
                                  onChanged: (Color? newValue) {
                                    setStateDialog(() {
                                      selectedColor = newValue!;
                                    });
                                  },
                                  items: Colors.primaries.map<DropdownMenuItem<Color>>((Color value) {
                                    return DropdownMenuItem<Color>(
                                      value: value,
                                      child: ColoredCircle(height: 14, width: 14, color: value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RoundedButton(
                        text: AppLocalizations.of(context)!.add,
                        onPressed: () {
                          if (categoryNameController.text.isNotEmpty && categoryNameController.text.length > 2) {
                            Category newCategory = Category(
                                "", categoryNameController.text, "", 0, 0, _currentSalonId, selectedColor?.value);

                            _categoriesBloc.addCategory(newCategory);

                            Get.back();
                          }
                        }),
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  void dispose() {
    _categoriesBloc.dispose();

    super.dispose();
  }
}
