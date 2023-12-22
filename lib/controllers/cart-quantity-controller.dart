

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProductQuantityController extends GetxController{
  RxInt soluong = 0.obs;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    fetchProductQuantity();
    super.onInit();
  }

  void fetchProductQuantity() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    int sum = 0;
    for(final doc in snapshot.docs){
      final data = doc.data();
      if(data != null && data.containsKey('productQuantity')){
        sum += (data['productQuantity']as num).toInt();
      }
    }
    soluong.value = sum;
    print("Day la soluong ");
    print(soluong.value);
  }
}