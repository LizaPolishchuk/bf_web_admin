import 'package:flutter/material.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/services_page/categories_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/rounded_button.dart';
import 'package:salons_adminka/prezentation/widgets/table_widget.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesPage extends StatefulWidget {
  final Salon? salon;

  const ServicesPage({Key? key, this.salon}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  Category? _selectedCategory;
  late CategoriesBloc _categoriesBloc;
  late String _currentSalonId;

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _categoriesBloc = getItWeb<CategoriesBloc>();
    _categoriesBloc.getCategories(_currentSalonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: "Услуги"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: _buildCategoriesSelector()),
              InkWell(
                onTap: () {
                  _showAddCategoryDialog();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: const Text(
                    "Добавить +",
                    style: AppTextStyle.hintText,
                  ),
                ),
              ),
              const SizedBox(width: 120),
              const SizedBox(
                  width: 360,
                  child: TextField(
                    style: AppTextStyle.bodyText,
                    decoration: InputDecoration(
                      counterText: "",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      hintStyle: AppTextStyle.hintText,
                      fillColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: "Поиск услуги",
                      prefixIcon: Align(widthFactor: 1.0, heightFactor: 1.0, child: Icon(Icons.search)),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(child: TableWidget()),
        ],
      ),
    );
  }

  Widget _buildCategoriesSelector() {
    return SizedBox(
      height: 25,
      child: StreamBuilder<List<Category>>(
          stream: _categoriesBloc.categoriesLoaded,
          builder: (context, snapshot) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryItem(null);
                }
                return _buildCategoryItem(snapshot.data![index - 1]);
              },
              itemCount: (snapshot.data?.length ?? 0) + 1,
            );
          }),
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
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.hintColor,
                        ),
                      ),
                    ),
                    const Text(
                      "Добавить новую категорию",
                      style: AppTextStyle.bodyText,
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
                                  style: AppTextStyle.bodyText,
                                  controller: categoryNameController,
                                  decoration: const InputDecoration(
                                    hintText: "Название категории",
                                    counterText: "",
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    hintStyle: AppTextStyle.hintText,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
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
                                )

                                // Container(
                                //   height: 14,
                                //   width: 14,
                                //   decoration: BoxDecoration(
                                //     color: Colors.red,
                                //     borderRadius: BorderRadius.circular(50),
                                //   ),
                                // ),
                                )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RoundedButton(
                        text: "Добавить",
                        onPressed: () {
                          Category newCategory = Category(
                            "",
                            categoryNameController.text,
                            "",
                            0,
                            0,
                            _currentSalonId,
                            selectedColor?.value,
                          );

                          _categoriesBloc.addCategory(newCategory);

                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget _buildCategoryItem(Category? category) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _selectedCategory == category ? AppColors.darkRose : AppColors.hintColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category != null) ColoredCircle(color: Color(category.color ?? 0xFFFFFFFF)),
            Text(
              category != null ? category.name : "Все услуги",
              style: AppTextStyle.hintText
                  .copyWith(color: _selectedCategory == category ? AppColors.darkRose : AppColors.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
