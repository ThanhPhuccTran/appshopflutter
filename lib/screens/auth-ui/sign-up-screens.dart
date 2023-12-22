import 'package:appshopflutter/controllers/sign-up-controller.dart';
import 'package:appshopflutter/screens/auth-ui/login-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScrendoryColor,
          elevation: 0,
          title: const Text(
            "Đăng Ký",
            style: TextStyle(
              color: AppConstant.appTextColor,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // cho phép cuộn vượt ra ngoài giới hạn
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Đăng ký để được nhiều ưu đãi",
                    style: TextStyle(
                      color: AppConstant.appScrendoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 30,
                ),
                //email
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appScrendoryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
                //User
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: username,
                        cursorColor: AppConstant.appScrendoryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Họ Tên",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
                //SoDt
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userPhone,
                        cursorColor: AppConstant.appScrendoryColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Số Điện Thoại",
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(
                      () => TextFormField(
                        controller: userPassword,
                        obscureText: signUpController.isPasswordVisible.value,
                        cursorColor: AppConstant.appScrendoryColor,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Mật Khẩu",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                signUpController.isPasswordVisible.toggle();
                              },
                              child: signUpController.isPasswordVisible.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Get.height / 30,
                ),
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 12,
                    decoration: BoxDecoration(
                      color: AppConstant.appMainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      child: const Text(
                        "Đăng Ký",
                        style: TextStyle(
                            color: AppConstant.appTextColor, fontSize: 18),
                      ),
                      onPressed: () async {
                        String name = username.text.trim();
                        String email = userEmail.text.trim();
                        String phone = userPhone.text.trim();
                        String password = userPassword.text.trim();
                        String userDeviceToken = '';

                        if (name.isEmpty ||
                            email.isEmpty ||
                            phone.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(
                            "Đăng ký thất bại",
                            "Vui lòng nhập đầy đủ thông tin",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScrendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signUpController.signUpMethod(
                                  email,
                                  name,
                                  phone,
                                  password,
                                  userDeviceToken,
                              );
                            if(userCredential!=null){
                              Get.snackbar(
                                "ĐĂNG KÝ THÀNH CÔNG",
                                "Đăng nhập ngay bây giờ",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appScrendoryColor,
                                colorText: AppConstant.appTextColor,
                              );
                              FirebaseAuth.instance.signOut();
                              Get.offAll(()=>LoginScreen());
                            }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bạn đã có tài khoản? ",
                      style: TextStyle(color: AppConstant.appScrendoryColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => const LoginScreen()),
                      // chuyển trang
                      child: const Text(
                        "Đăng nhập ngay",
                        style: TextStyle(
                            color: AppConstant.appScrendoryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
