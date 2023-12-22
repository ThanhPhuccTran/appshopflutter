

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/user-panel/search-screen.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchWidget> {
  // TextEditingController _searchController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Row(
        children: [
          Expanded(child: SizedBox(
            height: 40,
            child: TextFormField(
              readOnly: true,
              // controller: _searchController,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(color: Colors.grey)),
                hintText: "Tìm kiếm sản phẩm",
                hintStyle: TextStyle(fontSize: 20,)
                ),
              onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>SearchScreen())),
                ),
              ),
            ),
          GestureDetector(
            child: Container(
              height: 40,
              width: 40,
              color: Colors.yellow,
              child: Center(
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
