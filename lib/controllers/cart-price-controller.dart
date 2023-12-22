import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductPriceController extends GetxController {
  RxInt total = 0.obs;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    fetchProductPrice();
    super.onInit();
  }

  void fetchProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    int sum = 0;
    for(final doc in snapshot.docs){
      final data = doc.data();
      if(snapshot.docs.isEmpty&&data==null){
        sum = 0;
      }
      else if(data != null && data.containsKey('productTotalPrice')){
            sum += (data['productTotalPrice']as num).toInt();
      }

    }
    total.value = sum;
    print("Day la total 2 ");
    print(total.value);
  }
}
