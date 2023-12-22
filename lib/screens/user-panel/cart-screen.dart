import 'package:appshopflutter/controllers/cart-price-controller.dart';
import 'package:appshopflutter/controllers/cart-quantity-controller.dart';
import 'package:appshopflutter/models/CartModel.dart';
import 'package:appshopflutter/models/categories-model.dart';
import 'package:appshopflutter/screens/user-panel/check-out-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/products-model.dart';
import '../../utils/app-constant.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final  ProductPriceController productPriceController = Get.put(ProductPriceController());
  final ProductQuantityController productQuantityController = Get.put(ProductQuantityController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "Giỏ hàng của bạn ",
              style: TextStyle(color: Colors.black),
            ),
            Obx(() => Text("Số lượng : ${productQuantityController.soluong.value}", style: Theme.of(context).textTheme.caption)),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(user!.uid)
              .collection('cartOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Lỗi"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {

              return Center(
                child: Text("Không tìm thấy sản phẩm"),
              );
            }
            if (snapshot.data != null) {
              print("hello");
              print(user!.uid);
              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {

                      final cartData = snapshot.data!.docs[index];
                      CartModel cartModel = CartModel(
                          maloai: cartData['maloai'],
                          masanpham: cartData['masanpham'],
                          tenloai: cartData['tenloai'],
                          tensanpham: cartData['tensanpham'],
                          gia: cartData['gia'],
                          giamgia: cartData['giamgia'],
                          isSale: cartData['isSale'],
                          anhsanpham: cartData['anhsanpham'],
                          gioithieu: cartData['gioithieu'],
                          ngaygiao: cartData['ngaygiao'],
                          productQuantity: cartData['productQuantity'],
                          productTotalPrice: double.parse(
                              cartData['productTotalPrice'].toString()));
                      print("Tổng tiền là : ");
                      print(cartModel.productTotalPrice);
                      String giaString = cartModel.gia.replaceAll('.', '');

                      double giaDouble = double.parse(giaString);


                      double total = cartModel.productTotalPrice;


                      final formatter = NumberFormat('#,###');
                      String totalString = formatter.format(total);
                      print("Tong tien String la "+totalString);

                      //total
                      productPriceController.fetchProductPrice();

                      productQuantityController.fetchProductQuantity();
                      print("Day la tong tien tong the");
                      int tong = productPriceController.total.value;
                      String tongString = formatter.format(tong);
                      print(productPriceController.total.value);
                      return SwipeActionCell(
                        key: ObjectKey(cartModel.masanpham),
                        trailingActions: [
                          SwipeAction(
                            title: "Xóa",
                            forceAlignmentToBoundary: true,
                            performsFirstActionWithFullSwipe: true,
                            onTap: (CompletionHandler handler) async {
                              print("xoa");

                              FirebaseFirestore.instance
                                  .collection('cart')
                                  .doc(user!.uid)
                                  .collection('cartOrders')
                                  .doc(cartModel.masanpham)
                                  .delete();
                              productPriceController.fetchProductPrice();
                              productQuantityController.fetchProductQuantity();
                            },
                          ),
                        ],
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: CircleAvatar(
                                child: Image.network(cartModel.anhsanpham[0],fit: BoxFit.fill,),
                              ),
                            ),
                            title: Text(cartModel.tensanpham),
                            subtitle: Row(
                              children: [
                                // Text('${productPriceController.total.value}'),
                                Text(totalString),
                                SizedBox(
                                  width: Get.width / 4.0,
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    if(cartModel.productQuantity >1){
                                      FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.masanpham)
                                          .update({
                                        'productQuantity' : cartModel.productQuantity - 1,
                                        'productTotalPrice' :
                                        ((giaDouble)*(cartModel.productQuantity-1)),
                                      });
                                    }
                                    print("Tien");
                                    print(giaDouble);
                                    print("Day la productTotalPrice");
                                    print((giaDouble)*(cartModel.productQuantity-1));
                                  },
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    child: Text(("-")),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: Text('${cartModel.productQuantity}'),
                                ),
                                SizedBox(
                                  width: Get.width / 10.0,
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    if(cartModel.productQuantity >0){
                                      FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.masanpham)
                                          .update({
                                        'productQuantity' : cartModel.productQuantity + 1,
                                        'productTotalPrice' :
                                        ((giaDouble)*(cartModel.productQuantity+1)),
                                      });
                                    }
                                    print("Cong");
                                    print(giaDouble);
                                    print("Day la productTotalPrice");
                                    print((giaDouble)+(giaDouble)*(cartModel.productQuantity));
                                  },
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    child: Text("+"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
            return Text('');
          }),
      bottomNavigationBar: Card(
        child: Row(

          children: <Widget>[

            Expanded(
              child: Text('Tất cả'),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget> [
                      Text("Tổng thanh toán :"),
                      Obx(() => Text(NumberFormat('#,###').format(productPriceController.total.value),),),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppConstant.appScrendoryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 13),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed:(){ Get.to(()=>CheckOutScreen());},
                          child: Text(
                            'Mua hàng',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
