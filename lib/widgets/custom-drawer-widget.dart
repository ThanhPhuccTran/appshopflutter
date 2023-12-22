import 'package:appshopflutter/screens/auth-ui/WelcomeScreen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controllers/get-user-data-controller.dart';
import '../models/user-model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});



  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());

  Future<String> getUsername() async {
    List<QueryDocumentSnapshot<Object?>> userData = await getUserDataController.getUserData(user!.uid);
    if (userData.isNotEmpty) {
      UserModel userModel = UserModel.fromMap(userData[0].data() as Map<String, dynamic>);
      return userModel.username;
    } else {
      throw Exception('No user found with this uId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        )),
        backgroundColor: AppConstant.appScrendoryColor,
        child: Wrap(
          runSpacing: 10,
          children: [
            FutureBuilder<String>(
              future: getUsername(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(
                          snapshot.data!,
                          style: const TextStyle(color: AppConstant.appTextColor),
                        ),
                        subtitle: const Text("Version 1.0.1",
                            style: TextStyle(color: AppConstant.appTextColor)),
                        leading: CircleAvatar(
                          radius: 22.0,
                          backgroundColor: AppConstant.appMainColor,
                          child: Text(snapshot.data![0],
                              style:
                                  const TextStyle(color: AppConstant.appTextColor)),
                        ),
                      ),
                    );
                  }
                }
              },
            ),

            // Dấu gạch ngang
            const Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Trang chủ",
                    style: TextStyle(color: AppConstant.appTextColor)),
                leading: Icon(
                  Icons.home,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Sản phẩm",
                    style: TextStyle(color: AppConstant.appTextColor)),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Giỏ hàng",
                    style: TextStyle(color: AppConstant.appTextColor)),
                leading: Icon(
                  Icons.shopping_bag,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Tư vấn",
                    style: TextStyle(color: AppConstant.appTextColor)),
                leading: Icon(
                  Icons.help,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  googleSignIn.signIn();
                  Get.offAll(() => WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text("Đăng xuất",
                    style: TextStyle(color: AppConstant.appTextColor)),
                leading: const Icon(
                  Icons.logout_outlined,
                  color: AppConstant.appTextColor,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
