import 'package:appshopflutter/controllers/sign-in-controller.dart';
import 'package:appshopflutter/screens/auth-ui/sign-up-screens.dart';
import 'package:appshopflutter/screens/user-panel/main-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScrendoryColor,
          elevation: 0,
          title: Text(
            "Đăng Nhập",
            style: TextStyle(
              color: AppConstant.appTextColor,
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              isKeyboardVisible
                  ? Text("Đăng nhập để trải nghiệm")
                  : Container(
                      decoration: BoxDecoration(
                        color: AppConstant.appScrendoryColor,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            // Kích thước rộng tối đa của container
                            height: 300,
                            // Kích thước chiều cao của container
                            child: Center(
                              child: Transform.scale(
                                scale: 1,
                                // Tỉ lệ thu nhỏ của Lottie (0.5 là một ví dụ)
                                child: Lottie.asset(
                                  'assets/images/animation-icon3.json',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: Get.height / 30,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: userEmail,
                      cursorColor: AppConstant.appScrendoryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(
                      () => TextFormField(
                        controller: userPassword,
                        obscureText: signInController.isPasswordVisible.value,
                        cursorColor: AppConstant.appScrendoryColor,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Mật Khẩu",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signInController.isPasswordVisible.toggle();
                            },
                            child: signInController.isPasswordVisible.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerRight,
                child: Text(
                  "Bạn quên mật khẩu?",
                  style: TextStyle(
                      color: AppConstant.appScrendoryColor,
                      fontWeight: FontWeight.bold),
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
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(
                          color: AppConstant.appTextColor, fontSize: 18),
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar(
                          "Lỗi",
                          "Bạn chưa nhập đầy đủ thông tin",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appScrendoryColor,
                          colorText: AppConstant.appTextColor,
                        );
                      } else {

                        UserCredential? userCredential = await signInController
                            .signInMethod(email, password);
                        if (userCredential != null) {
                          if (userCredential.user!.emailVerified) {
                            Get.snackbar(
                              "Thành công",
                              "Đăng nhập thành công",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appScrendoryColor,
                              colorText: AppConstant.appTextColor,
                            );
                            Get.offAll(() => MainScreen());
                          } else {
                            Get.snackbar(
                              "Lỗi",
                              "Lỗi email hay gì đó",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appScrendoryColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Lỗi",
                            "Hãy kiểm tra lại ",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScrendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
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
                  Text(
                    "Bạn chưa có tài khoản? ",
                    style: TextStyle(color: AppConstant.appScrendoryColor),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUpScreen())); // chuyển trang có trở về
                      },
                      child: Text(
                        "Đăng ký ngay",
                        style: TextStyle(
                            color: AppConstant.appScrendoryColor,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
