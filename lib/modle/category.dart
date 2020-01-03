// 建立分类页数据模型
class CategoryBigModel {
  String mallCategoryId; // 列别编号
  String mallCategoryName; // 列别名称
  List<dynamic> bxMallSubDto; // 子类列表
  Null comments; //列表描述
  String image; //类别图片

  // 构造函数
  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.comments,
    this.image,
  });

  // 工厂模式-用这种模式可以省略New关键字
  factory CategoryBigModel.fromJson(dynamic json) {
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      bxMallSubDto: json['bxMallSubDto'],
      comments: json['comments'],
      image: json['image'],
    );
  }
}

// 定义个列表的模型
class CategoryBigListModel {
  List<CategoryBigModel> data;
  CategoryBigListModel(this.data);
  factory CategoryBigListModel.fromJson(List json) {
    return CategoryBigListModel(
      json.map((item) => CategoryBigModel.fromJson((item))).toList()
    );
  }
}
