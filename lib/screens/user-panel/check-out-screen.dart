import 'package:appshopflutter/controllers/cart-price-controller.dart';
import 'package:appshopflutter/controllers/cart-quantity-controller.dart';
import 'package:appshopflutter/models/CartModel.dart';
import 'package:appshopflutter/models/categories-model.dart';
import 'package:appshopflutter/screens/user-panel/main-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/products-model.dart';
import '../../services/place-order-service.dart';
import '../../utils/app-constant.dart';
import 'confirm-screen.dart';

class CheckOutScreen extends StatefulWidget {

  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreen();
}

class _CheckOutScreen extends State<CheckOutScreen> {
  late  String name = '';
  late  String phoneNumber = '';
  late  String address = '';
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  final ProductQuantityController productQuantityController =
      Get.put(ProductQuantityController());
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      phoneNumber = prefs.getString('phoneNumber') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Name');
    print('${name}');
    print("address");
    print('${address}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Thanh toán ",
          style: TextStyle(color: Colors.black),
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
              return Column(
                children: [
                  Container(child: Column(
                    children: [
                      Text('${address}'),
                      TextButton(onPressed: ()=> _onButtonXacNhan(context), child: Text("Chuyen trang"),),
                    ],
                  ),),
                  Container(
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
                          print("Tong tien String la " + totalString);

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
                                    child: Image.network(
                                      cartModel.anhsanpham[0],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(cartModel.tensanpham),
                                    Text('x${cartModel.productQuantity}'),
                                    Text(name),

                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    // Text('${productPriceController.total.value}'),
                                    Text(totalString),
                                    SizedBox(
                                      width: Get.width / 4.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
            return Text('');
          }),
      bottomNavigationBar: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Tổng thanh toán :"),
                  Obx(
                    () => Text(
                      NumberFormat('#,###')
                          .format(productPriceController.total.value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(),
            GestureDetector(
              onTap: () => handleTap(),
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: AppConstant.appScrendoryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 13),
                  child: Column(
                    children: [
                      Text(
                        'Đặt Hàng',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onButtonXacNhan(BuildContext context) async {
    bool xacnhan = await showDialog(
      context: context,
      builder: (BuildContext context) {
        //tạo ra một dialog
        return AlertDialog(
          content: const Text("Vui lòng nhập địa chỉ nhận hàng"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Thoát")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Đồng ý")),
          ],
        );
      },
    );

    if (xacnhan ?? false) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmScreen(
              totalPayment: productPriceController.total.value.toDouble(),
              name: '',
              address: '',
              phoneNumber: '',

            ),
          ));
    }

  }

  void handleTap() {
    print("cao");
    if (name == null || name.isEmpty) {
      print("DAVAO DUOC DAY");
      _onButtonXacNhan(context);
    } else {
      placeOrder(
        context: context,
        customerName : name,
        customerPhone :phoneNumber ,
        customerAddress : address,

      );
    }
  }
}
