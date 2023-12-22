import 'package:appshopflutter/models/OrderModel.dart';
import 'package:appshopflutter/screens/user-panel/main-screen.dart';
import 'package:appshopflutter/services/genrate-order-id-service.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/CartModel.dart';

void placeOrder({required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Làm ơn chờ ... ");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
          maloai: data['maloai'],
          masanpham: data['masanpham'],
          tenloai: data['tenloai'],
          tensanpham: data['tensanpham'],
          gia: data['gia'],
          giamgia: data['giamgia'],
          isSale: data['isSale'],
          anhsanpham: data['anhsanpham'],
          gioithieu: data['gioithieu'],
          ngaygiao: data['ngaygiao'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerAddress: customerAddress,
          customerPhone: customerPhone,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerAddress': customerAddress,
              'orderStatus': false,
              'createdAt': DateTime.now(),
            },
          );
          //upload orders

          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('xacnhanthanhtoan')
              .doc(orderId)
              .set(cartModel.toMap());

          //delete gio hang
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.masanpham.toString()).delete()
              .then((value) {
            print('Xoa gio hang ${cartModel.masanpham.toString()}');
          });
        }
      }
      print("Xac Nhan Order");
      Get.snackbar("Xác nhận Thanh Toán", "Cám ơn bạn đã mua hàng",
        backgroundColor: AppConstant.appMainColor, colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      EasyLoading.dismiss();
      Get.offAll(()=>MainScreen());
    } catch (e) {
      print("Lỗi $e");
    }
  }
}
