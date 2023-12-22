import 'package:appshopflutter/controllers/google-sign-in-controller.dart';
import 'package:appshopflutter/screens/auth-ui/login-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appScrendoryColor,
        elevation: 0,
        title: Text("Chào mừng bạn đã đến app của chúng tôi "),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(

              child: Lottie.asset('assets/images/animation-icon3.json',),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                "FLUX SHOPPING",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Material(
              child: Container(
                width: Get.width / 1.3,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    "assets/images/logo-google.png",
                    width: Get.width / 12,
                    height: Get.height / 12,
                  ),
                  label: Text("Đăng nhập bằng google",style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },
                ),
              ),
            ),

            SizedBox(
              height: Get.height / 35,
            ),
            Material(
              child: Container(
                width: Get.width / 1.3,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton.icon(
                  icon: Icon(Icons.email,color: AppConstant.appTextColor,),
                  label: Text("Đăng nhập bằng email",style: TextStyle(color: AppConstant.appTextColor),),
                  onPressed: () {
                    Get.to(()=>LoginScreen());
                  },
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
