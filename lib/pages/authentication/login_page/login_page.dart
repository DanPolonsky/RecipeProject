
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/authentication/signup_page/signup_page.dart';

import 'package:provider/provider.dart';

import 'login_page_provider.dart';

class LoginPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginPageProvider>(
      builder: (BuildContext context, provider, Widget child) => Scaffold(
        appBar: AppBar(leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            provider.reset();
            Navigator.pop(context);
          },
        ),),
        body: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0,10,0,20),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40
                  ),
                ),
              ),

              Form(
                key: provider.formKey,
                child:Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: TextFormField(
                          controller: provider.userNameTextController,

                          decoration: InputDecoration(

                              hintText: 'Enter username ...'
                          ),

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter username.';
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: TextFormField(
                          controller: provider.passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(

                              hintText: 'Enter password ...'
                          ),

                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password.';
                            }
                            return null;
                          },
                        ),
                      ),
                      provider.waitingCircle,

                      Container(
                        margin: EdgeInsets.only(top:5, bottom:5),
                        child: Text(provider.errorMsg,style: TextStyle(color: Colors.red[600]),),
                      ),

                      ElevatedButton(
                              onPressed: () async {
                                provider.reset();
                                Navigator.pushReplacement(
                                  context, CupertinoPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
                              child: Text("Sign Up")
                      ),


                      ElevatedButton(
                          onPressed: () async {
                            await provider.sendLoginRequest();
                            if(provider.closeLoginPage){
                              provider.reset();
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Login In")
                      )
                    ],
                  ),
                ),

              )

            ],
          ),
        )
      ),
    );
  }
}

