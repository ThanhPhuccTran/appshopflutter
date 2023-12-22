import 'package:appshopflutter/models/products-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/product-detail-screen.dart';

class FlashSale extends StatelessWidget {

  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('sanpham')
            .where('isSale', isEqualTo: true)
            .get(),
        // goi toi FirebaseFirestore de lay du lieu cot san pham
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Lỗi"),
            );
          }
          double screenWidth = MediaQuery.of(context).size.width;
          double itemWidth = (screenWidth - 40) / 2;
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
              return Container(
                // color: Colors.white,
                // height: Get.height / 5,
                height: 260,

                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
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
                      ngaygiao: productData['ngaygiao'],
                    );
                    print('Day la loi : ' + productModel.anhsanpham[1]);
                    return Card(
                      child: GestureDetector(
                        onTap: ()=>Get.to(()=>ProductDetailsScreen(productModel: productModel)),
                        child: Container(
                          width: 150,
                          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget> [

                              if(productModel.isSale == true)...[
                                Stack(
                                  children: [
                                    Positioned(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrange,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text("-"+productModel.giamgia),
                                                ),
                                              ),
                                              Icon(Icons.favorite_border),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],

                                ),
                              ],
                              //anh
                              Image.network(
                                productModel.anhsanpham[0],
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 12),
                              //text

                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    height: twoLineHeight,
                                    child: Text(
                                      productModel.tensanpham,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        height: lineHeight,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              //gia
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(productModel.gia+ " VNĐ"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    // return Row(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(left: 3.0, right: 5.0),
                    //       child: Card(
                    //         child: Container(
                    //           child: FillImageCard(
                    //             width: Get.width / 4.0,
                    //             heightImage: Get.height / 8.0,
                    //             imageProvider: CachedNetworkImageProvider(
                    //
                    //               productModel.anhsanpham[0],
                    //
                    //             ),
                    //             title: Center(
                    //                 child: Text(
                    //                   productModel.tensanpham,
                    //                   style: TextStyle(
                    //                     fontSize: 12.0,
                    //                   ),
                    //                 )),
                    //             // footer: Text(''),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // );
                  },
                ),
              );
            }


          return Text('');
        });
  }
}
