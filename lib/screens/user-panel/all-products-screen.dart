import 'package:appshopflutter/models/products-model.dart';
import 'package:appshopflutter/screens/user-panel/product-detail-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tất Cả Sản Phẩm"),
        backgroundColor: AppConstant.appScrendoryColor,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('sanpham')
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
              double fontSize = 17.0;
              double lineHeight = 1.2;
              double twoLineHeight = 2 * fontSize * lineHeight;
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 320,
                  ),
                  itemBuilder: (context, index) {
                    final ProductData = snapshot.data!.docs[index];
                    ProductModel productModel = ProductModel(
                        maloai: ProductData['maloai'],
                        masanpham: ProductData['masanpham'],
                        tenloai: ProductData['tenloai'],
                        tensanpham: ProductData['tensanpham'],
                        gia: ProductData['gia'],
                        giamgia: ProductData['giamgia'],
                        isSale: ProductData['isSale'],
                        anhsanpham: ProductData['anhsanpham'],
                        gioithieu: ProductData['gioithieu'],
                        ngaygiao: ProductData['ngaygiao'],

                    );

                    print("Day la anh product " + productModel.anhsanpham[0]);
                    return GestureDetector(
                      onTap: ()=>Get.to(()=>ProductDetailsScreen(productModel: productModel)),
                      child: Container(
                        //height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
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
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Image.network(
                                productModel.anhsanpham[0],
                                height: 170,
                                width: 170,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                height: twoLineHeight,
                                child: Text(
                                  productModel.tensanpham,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    height: lineHeight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8,right: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        "₫",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        productModel.gia,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Đã bán 4,6k",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],

                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }

            return Text('');
          }),
    );
  }
}
