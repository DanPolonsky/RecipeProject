import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/providers/add_recipe_page_provider.dart';

import 'package:flutter_app/providers/recipe_list_provider.dart';
import 'package:flutter_app/widgets/add_recipe_page.dart';
import 'package:provider/provider.dart';
import 'classes/data_search.dart';
import 'widgets/waiting_page.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;


import 'dart:convert';
import 'package:convert/convert.dart';

void main(){
   return runApp(
     MultiProvider(providers: [
       ChangeNotifierProvider(create: (context) => CategoryRecipeListProvider()),
       ChangeNotifierProvider(create: (context) => SearchRecipeListProvider()),
       ChangeNotifierProvider(create: (context) => AddRecipePageProvider())
     ], child: MyApp()),
   );
}


void func() async{
  // way 1
  //  http.Response response = await http.get(Uri.http("192.168.11.105:5356","/login"));
//  print(response.bodyBytes);
//  final directory = await getApplicationDocumentsDirectory();
//  File pemFile = File("${directory.path}/publicKey.pem");
//  pemFile.writeAsBytes(response.bodyBytes);
//  final publicKey = await parseKeyFromFile<RSAPublicKey>("${directory.path}/publicKey.pem");
//  //print(publicKey.modulus);
//  print(publicKey.modulus.runtimeType);

  String password = "dan123";
  String userName = "some username";

  http.Response response = await http.get(Uri.http("192.168.11.105:5356","/login"));
  RSAPublicKey publicKey = RSAPublicKey(BigInt.parse(response.body.split(",")[0]), BigInt.parse(response.body.split(",")[1]));
  print(publicKey.modulus);

  Encrypter encrypter = Encrypter(RSA(publicKey: publicKey));
  final encrypted = encrypter.encrypt(password);
  print(encrypted.base64);


  http.post(
      Uri.http("192.168.11.105:5356","/verify"),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },

      //Todo: add id per user, to verify user.
      body: jsonEncode(<String, dynamic>{
        "userName": userName,
        "password":encrypted.base64
      }));


}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //func();
    return MaterialApp(title: 'Text-To-Speech Demo', home: WaitingPage());
    //return MaterialApp(title: "test",home:Text("dfgh"));
  }
}


class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryRecipeListProvider>(
      builder: (context, provider, child) =>
          Scaffold(
            appBar: AppBar(
              title: Text("Testing App"),
              centerTitle: true,

              leading: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddRecipePage()),
                    );
                  }),

              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      String result = await showSearch(
                          context: context, delegate: DataSearch());
                      print(result);
                    })
              ],
            ),

            body:
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,

                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4),
                            child: RaisedButton(
                              onPressed: () => provider.initializeNewCategory("meat", true),
                              child: Text("meat"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child: RaisedButton(
                              onPressed: () => provider.initializeNewCategory("meat", true),
                              child: Text("puk"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  child: NotificationListener<ScrollNotification>(

                    // add loading animation, maxScrollExtent-number of animation pixels
                    // ignore: missing_return
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          provider.downloadListCategory();
                        }
                      },
                      child: SingleChildScrollView(
                        controller: provider.scrollController,
                        child: Column(children: provider.categoryRecipeCardList),
                      )
                  ),
                )
              ],
            ),
          ),

    );
  }
}
