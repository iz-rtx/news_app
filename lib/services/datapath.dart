import 'package:news_app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> categories = [];

  final generalCategoryModel = CategoryModel()
    ..categoryName = "General"
    ..image = "assets/img/general.png";

  final healthCategoryModel = CategoryModel()
    ..categoryName = "Health"
    ..image = "assets/img/health.png";

  final businessCategoryModel = CategoryModel()
    ..categoryName = "Business"
    ..image = "assets/img/business.png";

  final entertainmentCategoryModel = CategoryModel()
    ..categoryName = "Entertainment"
    ..image = "assets/img/entertainment.png";

  final scienceCategoryModel = CategoryModel()
    ..categoryName = "Science"
    ..image = "assets/img/science.png";

  final sportsCategoryModel = CategoryModel()
    ..categoryName = "Sports"
    ..image = "assets/img/sports.png";

  categories.add(generalCategoryModel);
  categories.add(healthCategoryModel);
  categories.add(businessCategoryModel);
  categories.add(entertainmentCategoryModel);
  categories.add(scienceCategoryModel);
  categories.add(sportsCategoryModel);

  return categories;
}
