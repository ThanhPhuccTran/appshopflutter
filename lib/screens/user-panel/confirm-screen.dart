import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/cart-price-controller.dart';
import '../../utils/app-constant.dart';
import 'check-out-screen.dart';

class ConfirmScreen extends StatefulWidget {
  final double totalPayment;
  final String name;
  final String phoneNumber;
  final String address;

  const ConfirmScreen(
      {super.key,
      required this.totalPayment,
      required this.name,
      required this.phoneNumber,
      required this.address});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Địa chỉ nhận hàng",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Liên hệ'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextFormField(
                      controller: nameController,
                      cursorColor: AppConstant.appScrendoryColor,
                      decoration: InputDecoration(
                        hintText: "Họ và tên",
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextFormField(
                      controller: sdtController,
                      cursorColor: AppConstant.appScrendoryColor,
                      decoration: InputDecoration(
                        hintText: "Số điện thoại",
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Địa chỉ'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextFormField(
                      controller: addressController,
                      cursorColor: AppConstant.appScrendoryColor,
                      decoration: InputDecoration(
                        hintText: "Tỉnh/Thành Phố,Quận/Huyện,Phường/Xã",
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Tổng thanh toán",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("${widget.totalPayment}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (nameController != '' &&
                      sdtController != '' &&
                      addressController != '') {
                    String name = nameController.text.trim();
                    String sdt = sdtController.text.trim();
                    String address = addressController.text.trim();

                    //lưu dữ liệu
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setString('name',nameController.text);
                    pref.setString('sdt',sdtController.text);
                    pref.setString('address',addressController.text);

                    if (name.isNotEmpty && sdt.isNotEmpty && address.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckOutScreen(
                                // name: name,
                                // phoneNumber: sdt,
                                // address: address,
                              ),
                        ),
                      );
                    }
                  } else {
                    print("Dien Thong tin chi tiet");
                  }
                },
                child: Text("Hoàn Thành")),
          ],
        ),
      ),
    );
  }
}
