import 'package:appshopflutter/screens/auth-ui/WelcomeScreen.dart';
import 'package:appshopflutter/screens/user-panel/all-categories-screen.dart';
import 'package:appshopflutter/screens/user-panel/all-flash-sale-products.dart';
import 'package:appshopflutter/screens/user-panel/all-products-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:appshopflutter/widgets/all-products-widget.dart';
import 'package:appshopflutter/widgets/banner-widget.dart';
import 'package:appshopflutter/widgets/category-widget.dart';
import 'package:appshopflutter/widgets/custom-drawer-widget.dart';
import 'package:appshopflutter/widgets/flash-sale-widget.dart';
import 'package:appshopflutter/widgets/heading-widget.dart';
import 'package:appshopflutter/widgets/search-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName),
        centerTitle: true,
        actions: [
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              SizedBox(height: Get.height/90.0,),
              const SearchWidget(),

              //banner
              const BannerWidget(),
              ListTile(
                title: Text("Loại sản phẩm",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                trailing: TextButton(
                  child: Text("Xem Thêm",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  onPressed: () => Get.to(() => AllCategoriesScreen()),
                ),
              ),

              Card(child: CategoriesWidget()),
              ListTile(
                title: Text("Flash Sale",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                trailing: TextButton(
                  child: Text("Xem Thêm",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  onPressed: () => Get.to(() => AllFlashSaleProduct()),
                ),
              ),
              FlashSale(),
              ListTile(
                title: Text("Tất Cả Sản Phẩm",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                trailing: TextButton(
                  child: Text("Xem Thêm",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  onPressed: () => Get.to(()=>AllProductsScreen()),
                ),
              ),
              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
