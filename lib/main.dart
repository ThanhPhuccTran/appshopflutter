import 'package:appshopflutter/screens/auth-ui/WelcomeScreen.dart';
import 'package:appshopflutter/screens/auth-ui/login-screen.dart';
import 'package:appshopflutter/screens/auth-ui/sign-up-screens.dart';
import 'package:appshopflutter/screens/user-panel/cart-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:appshopflutter/screens/auth-ui/animation-screen.dart';
import 'package:appshopflutter/screens/user-panel/main-screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDsf2fMUah4tlRJ_qYFcsZBHnv_HocVErU",
            appId: "1:877231626281:web:951df36f71347c10076438",
            messagingSenderId: "877231626281",
            projectId: "shopapp-246ea"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: AnimationScreen(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      // initialRoute: '/', // Thiết lập tuyến đường ban đầu
      // // Định nghĩa các routes
      // getPages: [
      //   // GetPage(name: '/', page: () => AnimationScreen()),
      //  // GetPage(name: '/MainScreen', page: () => MainScreen()),
      //   GetPage(name: '/LoginScreen', page: () => LoginScreen()),
      //   // Thêm các tuyến đường khác nếu cần
      // ],
    );
  }
}
