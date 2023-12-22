import 'package:appshopflutter/models/categories-model.dart';
import 'package:appshopflutter/models/products-model.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoriesProductsScreen extends StatefulWidget {
  String maloai;
  AllCategoriesProductsScreen({super.key, required this.maloai});

  @override
  State<AllCategoriesProductsScreen> createState() =>
      _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản Phẩm"),
        backgroundColor: AppConstant.appScrendoryColor,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('sanpham')
              .where('maloai', isEqualTo: widget.maloai)
              .get(),
          // goi toi FirebaseFirestore de lay du lieu cot san pham
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Lỗi"),
              );
            }
            //cho lay du lieu
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            //neu khong co du lieu
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("Không tìm thấy sản phẩm"),
              );
            }
            if (snapshot.data != null) {
              //chinh de text luon 2 dong
              double fontSize = 14.0;
              double lineHeight = 1.2;
              double twoLineHeight = 2 * fontSize * lineHeight;
              return SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 700,
                  width: 500,
                  // padding: EdgeInsets.symmetric(vertical: 50),
                  child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      // CategoriesModel categoriesModel = CategoriesModel(
                      //   maloai: snapshot.data!.docs[index]['maloai'],
                      //   anhloai: snapshot.data!.docs[index]['anhloai'],
                      //   tenloai: snapshot.data!.docs[index]['tenloai'],
                      // );
                      final productData = snapshot.data!.docs[index];
                      ProductModel productModel = ProductModel(
                          maloai: productData['maloai'],
                          masanpham: productData['masanpham'],
                          tenloai: productData['tenloai'],
                          tensanpham: productData['tensanpham'],
                          gia: productData['gia'],
                          giamgia: productData['giamgia'],
                          isSale: productData['isSale'],
                          anhsanpham: productData['anhsanpham'],
                          gioithieu: productData['gioithieu'],
                          ngaygiao: productData['ngaygiao']);
                      return InkWell(
                        onTap: () {
                          print("index $index");
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6),
                            ],
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                            child: Stack(
                              
                              children :<Widget>[
                                Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Image.network(
                                  //   productModel.anhsanpham[0],
                                  //   fit: BoxFit.cover,
                                  //   width: 120,
                                  //   height: 100,
                                  // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Text(
                                  //   productModel.tensanpham,
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold, fontSize: 17),
                                  // ),
                                  // if(productModel.isSale == true)...[
                                  //   Visibility(
                                  //     visible: productModel.isSale,
                                  //     child: Stack(
                                  //       children: [
                                  //         Positioned(
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.all(8.0),
                                  //               child: Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //                 children: [
                                  //                   Container(
                                  //                     decoration: BoxDecoration(
                                  //                       color: Colors.deepOrange,
                                  //                     ),
                                  //                     child: Padding(
                                  //                       padding: const EdgeInsets.all(2.0),
                                  //                       child: Text("-"+productModel.giamgia),
                                  //                     ),
                                  //                   ),
                                  //                   Icon(Icons.favorite_border),
                                  //                 ],
                                  //               ),
                                  //             )
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     replacement: Icon(Icons.favorite_border),
                                  //   ),
                                  // ],
                                  //anh
                                  //Anh
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      child: Image.network(
                                        productModel.anhsanpham[0],
                                        width: 400,
                                        height: 400,
                                        //fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  //ten
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              10, 4, 0, 0),
                                          child: Text(
                                            productModel.tensanpham,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //gia
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 4, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 2, 0, 0),
                                          child: Text(
                                            productModel.gia,
                                            style: TextStyle(
                                              color: Colors.black26,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                                if(productModel.isSale == true)...[
                                  Positioned(
                                    //top: 50,
                                    //right: 20,
                                    child: Container(
                                      width: 42,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text("-"+productModel.giamgia),
                                      ),
                                    ),
                                  ),
                                ],
                            ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Text('');
          }),
    );
  }
}
