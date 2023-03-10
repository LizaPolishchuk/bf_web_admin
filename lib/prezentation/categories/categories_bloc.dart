// import 'dart:async';
//
// import 'package:rxdart/rxdart.dart';
// import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
//
// class CategoriesBloc {
//   final GetCategoriesListUseCase _getCategoriesListUseCase;
//   final AddCategoryUseCase _addCategoryUseCase;
//   final UpdateCategoryUseCase _updateCategoryUseCase;
//   final RemoveCategoryUseCase _removeCategoryUseCase;
//
//   CategoriesBloc(this._getCategoriesListUseCase, this._addCategoryUseCase, this._updateCategoryUseCase,
//       this._removeCategoryUseCase);
//
//   List<Category> categoriesList = [];
//
//   final _categoriesLoadedSubject = PublishSubject<List<Category>>();
//   final _categoryAddedSubject = PublishSubject<bool>();
//   final _categoryUpdatedSubject = PublishSubject<bool>();
//   final _categoryRemovedSubject = PublishSubject<bool>();
//   final _errorSubject = PublishSubject<String>();
//   final _isLoadingSubject = PublishSubject<bool>();
//
//   // output stream
//   Stream<List<Category>> get categoriesLoaded => _categoriesLoadedSubject.stream;
//
//   Stream<bool> get categoryAdded => _categoryAddedSubject.stream;
//
//   Stream<bool> get categoryUpdated => _categoryAddedSubject.stream;
//
//   Stream<bool> get categoryRemoved => _categoryAddedSubject.stream;
//
//   Stream<String> get errorMessage => _errorSubject.stream;
//
//   Stream<bool> get isLoading => _isLoadingSubject.stream;
//
//   getCategories(String salonId) async {
//     var response = await _getCategoriesListUseCase(salonId);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       categoriesList = response.right;
//       _categoriesLoadedSubject.add(categoriesList);
//     }
//   }
//
//   addCategory(Category category) async {
//     var response = await _addCategoryUseCase(category);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       categoriesList.add(response.right);
//       _categoriesLoadedSubject.add(categoriesList);
//       _categoryAddedSubject.add(true);
//     }
//   }
//
//   updateCategory(Category category, int index) async {
//     var response = await _updateCategoryUseCase(category);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       categoriesList[index] = response.right;
//       _categoriesLoadedSubject.add(categoriesList);
//       _categoryUpdatedSubject.add(true);
//     }
//   }
//
//   removeCategory(String categoryId, int index) async {
//     var response = await _removeCategoryUseCase(categoryId);
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       categoriesList.removeAt(index);
//       _categoriesLoadedSubject.add(categoriesList);
//       _categoryRemovedSubject.add(true);
//     }
//   }
//
//   dispose() {}
// }
