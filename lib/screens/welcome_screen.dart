import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:food/models/cart.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/otp_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    Future.delayed(Duration(seconds: 2));
    var status = await Permission.locationWhenInUse.status;
    if (status.isUndetermined) {
      Permission.locationWhenInUse.request();
    }

    if (await Permission.locationWhenInUse.isRestricted) {
      Permission.locationWhenInUse.request();
    }
    if (await Permission.locationWhenInUse.isDenied) {
      Permission.locationWhenInUse.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: roundBorderButton(
                      35,
                      100,
                      'Skip',
                      Color(0xFF000000),
                      ChangeNotifierProvider(
                        create: (context) => Cart(),
                        child: HomePageScreen(),
                      )),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/logo.png',
                      height: 180,
                      width: 180,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Color(
                                0xFFF85547,
                              ),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'to',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Los ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Pollos ',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Harmanos',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Color(
                                0xFFF85547,
                              ),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                            controller: _controller,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: 17,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              counterText: "",
                              hintStyle: TextStyle(
                                  fontSize: 16, fontFamily: 'OpenSans'),
                              hintText: 'Enter your phone',
                              prefixText: ' +91 ',
                              prefixStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      OpenContainer(
                        transitionDuration: Duration(milliseconds: 350),
                        openColor: Color(0xFF202A36),
                        closedColor: Color(0xFF202A36),
                        closedBuilder: (context, open) {
                          return Ink(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(
                                0xFFF85547,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: open,
                              child: Center(
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                        openBuilder: (context, close) {
                          return OTPScreen(phone: '+91' + _controller.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  signingUser(String phone) async {
    if (validatePhoneNumber(phone)) {
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        phone: "+91" + phone,
                      )));
        }
      } catch (e) {
        _showSnackbar(context, 'No internet connection');
      }
    } else {
      _showSnackbar(context, 'Invalid Phone');
    }
  }

  bool validatePhoneNumber(String phone) {
    if (phone.length == 10) {
      String pattern = r'^[7-9]?[0-9]{9}$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(phone)) return true;
    }
    return false;
  }

  Widget roundBorderButton(double height, double width, String label,
      Color color, Object navigator) {
    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => navigator));
        },
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
