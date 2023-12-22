import 'package:appshopflutter/models/CartModel.dart';
import 'package:appshopflutter/models/products-model.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/cart-quantity-controller.dart';
import 'cart-screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;

  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

int indexx = 0;
//chinh de text luon 2 dong
double fontSize = 20.0;
double lineHeight = 1.2;
double twoLineHeight = 2 * fontSize * lineHeight;
PageController pageController = PageController(initialPage: indexx);

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductQuantityController productQuantityController = Get.put(ProductQuantityController());

  @override
  Widget build(BuildContext context) {
    List get_images = [
      widget.productModel.anhsanpham[0]!,
      widget.productModel.anhsanpham[1]!,
      widget.productModel.anhsanpham[2]!,
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text("Số lượng : ${productQuantityController.soluong.value}", style: Theme.of(context).textTheme.caption)),
            Container(
              height: 50,
              width: 160,
              decoration: BoxDecoration(
                color: AppConstant.appScrendoryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () async {
                  await checkProductExistence(uId: user!.uid);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    Text(
                      'Thêm vào giỏ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 18, bottom: 8, right: 10, left: 10),
                  child: Icon(Icons.shopping_cart),
                ),

                Positioned(
                  top: 15,
                  left: 4,
                    child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                  child: Obx
                    ( ()=>Text(
                      '${productQuantityController.soluong.value}', // Số lượng sản phẩm trong giỏ hàng
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                )),
              ]
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   height: 350,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       fit: BoxFit.fill,
              //       image: NetworkImage('${get_images[indexx]}',),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: get_images.length,
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: get_images[index],
                          fit: BoxFit.cover,
                          width: 700,
                          placeholder: (context, url) => const ColoredBox(
                            color: Colors.white,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      onPageChanged: (page) {
                        setState(() => indexx = page);
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${indexx + 1}/${get_images.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: twoLineHeight,
                          child: Text(
                            widget.productModel.tensanpham,
                            style: TextStyle(
                              fontSize: fontSize,
                              height: lineHeight,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: twoLineHeight,
                          child: Text(
                            widget.productModel.gia,
                            style: TextStyle(
                              fontSize: fontSize,
                              height: lineHeight,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      width: 700,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: index == 0 ? 0 : 24),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexx = index;
                                    pageController.jumpToPage(index);
                                  });
                                },
                                child: Container(
                                  height: 100,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.6,
                                      color: indexx == index
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage('${get_images[index]}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Giới thiệu',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        widget.productModel.gioithieu,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //kiểm tra xem có tồn tại hay không
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {

    //DocumentReference được tạo để tham chiếu đến một tài liệu cụ thể trong cơ sở dữ liệu.
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.masanpham.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updateQuantity = currentQuantity + quantityIncrement;

      //epkieu
      String giaString = widget.productModel.gia.replaceAll('.', '');
      double giaDouble = double.parse(giaString);

      // tong tien
      double totalPrice = (giaDouble * updateQuantity);
      print("Tong tien la");
      print(totalPrice);
      await documentReference.update({
        'productQuantity': updateQuantity,
        'productTotalPrice': totalPrice,
      }
      );
      Get.snackbar(
        "Thêm sản phẩm thành công",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScrendoryColor,
        colorText: AppConstant.appTextColor,
      );
      productQuantityController.fetchProductQuantity();
      print("product exists");

    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'ngaygiao': DateTime.now(),
        },
      );
      String giaString = widget.productModel.gia.replaceAll('.', '');
      double giaDouble = double.parse(giaString);


      CartModel cartModel = CartModel(
          maloai: widget.productModel.maloai,
          masanpham: widget.productModel.masanpham,
          tenloai: widget.productModel.tenloai,
          tensanpham: widget.productModel.tensanpham,
          gia: widget.productModel.gia,
          giamgia: widget.productModel.giamgia,
          isSale: widget.productModel.isSale,
          anhsanpham: widget.productModel.anhsanpham,
          gioithieu: widget.productModel.gioithieu,
          ngaygiao: DateTime.now(),
          productQuantity: 1,
          productTotalPrice: giaDouble);

      await documentReference.set(cartModel.toMap());
      Get.snackbar(
        "Thêm sản phẩm thành công",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScrendoryColor,
        colorText: AppConstant.appTextColor,
      );
      productQuantityController.fetchProductQuantity();
      print("san pham add ");
      print(widget.productModel.anhsanpham);
      print(giaDouble);
    }
  }
}
