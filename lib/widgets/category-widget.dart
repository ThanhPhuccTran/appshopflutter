import 'package:appshopflutter/models/categories-model.dart';
import 'package:appshopflutter/screens/user-panel/all-categories-products-screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('loaisanpham').get(),
        // goi toi FirebaseFirestore de lay du lieu cot san pham
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return SizedBox(
              // color: Colors.white,
              height: 120,
              //width: 500,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemExtent: 100,
                itemBuilder: (context, index) {
                  CategoriesModel categoriesModel = CategoriesModel(
                    maloai: snapshot.data!.docs[index]['maloai'],
                    anhloai: snapshot.data!.docs[index]['anhloai'],
                    tenloai: snapshot.data!.docs[index]['tenloai'],
                  );
                  // return Row(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.only(left: 3.0, right: 5.0),
                  //       child: Card(
                  //         child: Container(
                  //           child: FillImageCard(
                  //             width: Get.width / 4.0,
                  //             heightImage: Get.height / 9.0,
                  //             imageProvider: CachedNetworkImageProvider(
                  //               categoriesModel.anhloai,
                  //             ),
                  //             title: Center(
                  //                 child: Text(
                  //               categoriesModel.tenloai,
                  //               style: TextStyle(
                  //                 fontSize: 12.0,
                  //               ),
                  //             )),
                  //             // footer: Text(''),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // );
                  return GestureDetector(
                    onTap: () => Get.to(()=>AllCategoriesProductsScreen(maloai: categoriesModel.maloai)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              categoriesModel.anhloai,
                              fit: BoxFit.cover,
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                        Center(child: Text(categoriesModel.tenloai)),

                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Text('');
        });
  }
}
