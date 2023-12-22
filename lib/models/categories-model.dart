class CategoriesModel {
  final String maloai;
  final String anhloai;
  final String tenloai;

  CategoriesModel({
    required this.maloai,
    required this.anhloai,
    required this.tenloai,
  });
//cho phép bạn lưu trữ hoặc truyền đối tượng dưới dạng dữ liệu có thể mã hóa, chẳng hạn như JSON
  Map<String , dynamic> toMap(){
    return {
      'maloai': maloai,
      'anhloai' : anhloai,
      'tenloai' : tenloai,
    };
  }
  // tạo một cá thể từ JSON map
  factory CategoriesModel.fromMap(Map<String,dynamic> json){
    return CategoriesModel(
      maloai : json['maloai'],
      anhloai : json['anhloai'],
      tenloai : json['tenloai'],
    );
  }
}
