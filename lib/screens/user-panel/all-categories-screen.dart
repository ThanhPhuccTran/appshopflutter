import 'package:appshopflutter/models/categories-model.dart';
import 'package:appshopflutter/screens/user-panel/all-categories-products-screen.dart';
import 'package:appshopflutter/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả loại sản phẩm"),
        backgroundColor: AppConstant.appScrendoryColor,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('loaisanpham').get(),
          // goi toi FirebaseFirestore de lay du lieu cot san pham
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Lỗi"),
              );
            }
            //cho lay du lieu
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            //neu khong co du lieu
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("Không tìm thấy sản phẩm"),
              );
            }
            if (snapshot.data != null) {
              return SingleChildScrollView(
                child: Container(

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 700,
                  width: 500,
                 // padding: EdgeInsets.symmetric(vertical: 50),
                  child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      CategoriesModel categoriesModel = CategoriesModel(
                        maloai: snapshot.data!.docs[index]['maloai'],
                        anhloai: snapshot.data!.docs[index]['anhloai'],
                        tenloai: snapshot.data!.docs[index]['tenloai'],
                      );
                      return InkWell(
                        // onTap: () {
                        //   print("index $index");
                        // },
                        onTap: ()=>Get.to(()=>AllCategoriesProductsScreen(maloai : categoriesModel.maloai)),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6),
                            ],
                          ),
                          child : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(categoriesModel.anhloai,fit: BoxFit.cover,width: 120,height: 100,),
                              SizedBox(height: 20,),
                              Text(categoriesModel.tenloai,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Text('');
          }),
    );
  }
}
