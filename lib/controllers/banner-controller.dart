import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class bannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannerUrls();
  }

  //ferch banner
  Future<void> fetchBannerUrls() async {
    try {
      QuerySnapshot bannersSnapshot =
      await FirebaseFirestore.instance.collection('banners').get();
      if (bannersSnapshot.docs.isNotEmpty) {
        bannerUrls.value = bannersSnapshot.docs
            .map((doc) => doc['imageUrl'] as String)
            .toList();
      }
    } catch (e) {
      print("Loi : $e");
    }
  }
}
