class ProductModel {
  final String maloai;
  final String masanpham;
  final String tenloai;
  final String tensanpham;
  final String gia;
  final String giamgia;
  final bool isSale;
  final List anhsanpham;
  final String gioithieu;
  final dynamic  ngaygiao;

  ProductModel({
    required this.maloai,
    required this.masanpham,
    required this.tenloai,
    required this.tensanpham,
    required this.gia,
    required this.giamgia,
    required this.isSale,
    required this.anhsanpham,
    required this.gioithieu,
    required this.ngaygiao,
  });

  //cho phép bạn lưu trữ hoặc truyền đối tượng dưới dạng dữ liệu có thể mã hóa, chẳng hạn như JSON
  Map<String, dynamic> toMap() {
    return {
      'maloai': maloai,
      'masanpham': masanpham,
      'tenloai': tenloai,
      'tensanpham': tensanpham,
      'gia': gia,
      'giamgia': giamgia,
      'isSale': isSale,
      'anhsanpham': giamgia,
      'gioithieu': gioithieu,
      'ngaygiao': ngaygiao
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json){
    return ProductModel(
        maloai: json['maloai'],
        masanpham: json['masanpham'],
        tenloai: json['tenloai'],
        tensanpham: json['tensanpham'],
        gia: json['gia'],
        giamgia: json['giamgia'],
        isSale: json['isSale'],
        anhsanpham: json['anhsanpham'],
        gioithieu: json['gioithieu'],
        ngaygiao: json['ngaygiao'],
    );
  }
}
