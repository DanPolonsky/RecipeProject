
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/login_page_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginPageProvider>(
      builder: (BuildContext context, provider, Widget child) => Scaffold(
        appBar: AppBar(),
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
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Text(provider.errorMsg,style: TextStyle(color: Colors.red[600]),),
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
                              return 'Please enter username.';
                            }
                            return null;
                          },
                        ),
                      ),
                      provider.waitingCircle,
                      ElevatedButton(
                          onPressed: () async {
                            await provider.sendLoginRequest();
                            if(provider.closeLoginPage){
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

