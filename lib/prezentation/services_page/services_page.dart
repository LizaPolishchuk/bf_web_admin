import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
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
  final List<Category> _categoriesList = [Category("id", "name", "description", 100, 150, "creatorSalon", 0xffBA83FF)];

  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
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
              Flexible(child: _buildCategoriesSelector(_categoriesList)),
              const SizedBox(width: 120),
              const SizedBox(
                  width: 360,
                  child: TextField(
                    style: AppTextStyle.bodyText,
                    decoration: InputDecoration(
                      counterText: "",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

  Widget _buildCategoriesSelector(List<Category> categories) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryItem(null);
          } else if (index == 11) {
            return InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                  "Добавить +",
                  style: AppTextStyle.hintText,
                ),
              ),
            );
          }
          return _buildCategoryItem(categories[0]);
        },
        itemCount: 10 + 2,
      ),
    );
  }

  Widget _buildCategoryItem(Category? category) {
    return InkWell(
      onTap: () {
        setState((){
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
            if (category != null)
              Container(
                height: 10,
                width: 10,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: Color(category.color ?? 0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
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
