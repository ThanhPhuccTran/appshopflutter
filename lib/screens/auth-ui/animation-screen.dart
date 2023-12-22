import 'dart:async';

import 'package:appshopflutter/controllers/get-user-data-controller.dart';
import 'package:appshopflutter/screens/auth-ui/WelcomeScreen.dart';
import 'package:appshopflutter/screens/user-panel/main-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 5), () {
      loggdin(context);
    });

  }
  Future<void>loggdin(BuildContext context) async{
    if(user != null){
      final GetUserDataController getUserDataController = Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      if(userData[0]['isAdmin'] == true){

      }
      else{
        Get.offAll(()=>MainScreen());
      }
    }else{
      Get.to(()=> WelcomeScreen());
    }
  }


  //final size = MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appScrendoryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appScrendoryColor,
        elevation: 0,

      ),
      body: Container(
        child: Column(
          children:[

            Expanded(
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
               child: Lottie.asset('assets/images/animation-icon3.json'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                AppConstant.appPoweredBy,
                style: TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
