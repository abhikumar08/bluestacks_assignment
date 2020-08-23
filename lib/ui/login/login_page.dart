import 'package:bluestacks_assignment/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final formKey = new GlobalKey<FormState>();
  bool innerLoading = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isFormValid = false;
  LoginBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        _bloc = LoginBloc();
        return _bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, LoginState state) {},
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(
                        tag: "logo",
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 64),
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          controller: _userNameController,
                          autofocus: false,
                          validator: (val) {
                            return val.length < 1 ? "Username Required" : null;
                          },
                          onChanged: (val){
                            setState(() {
                              isFormValid = val.length >= 3 &&
                                  val.length <= 10 &&
                                  _passwordController.text.length <= 10 &&
                                  _passwordController.text.length >= 3;
                            });
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: "Username",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusColor: Colors.white,
                              fillColor: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          autofocus: false,
                          validator: (val) {
                            return val.length < 1 ? "Password Required" : null;
                          },
                          onChanged: (val){
                            setState(() {
                              isFormValid = val.length >= 3 &&
                                  val.length <= 10 &&
                                  _userNameController.text.length <= 10 &&
                                  _userNameController.text.length >= 3;
                            });
                          },
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusColor: Colors.white,
                              fillColor: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16, top: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: innerLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : RaisedButton(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      color: Colors.white,
                                      disabledColor: Colors.white30,
                                      disabledTextColor: Colors.white12,
                                      elevation: 8,
                                      onPressed: isFormValid
                                          ? () {
                                              print("on click");
                                              final form = formKey.currentState;
                                              if (form.validate()) {
                                                setState(() {
                                                  innerLoading = true;
                                                });
                                                _bloc.add(
                                                    new LoginWithUsernameAndPassword(
                                                        _userNameController
                                                            .text,
                                                        _passwordController
                                                            .text));
                                              }
                                            }
                                          : null,
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
