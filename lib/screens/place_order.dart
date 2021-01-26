import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/screens/get_location.dart';
import 'package:food/screens/homepage.dart';
import 'package:food/screens/loading.dart';
import 'package:food/screens/welcome_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaceOrderScreen extends StatefulWidget {
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool isLoading = true;
  String area = '';
  double distance;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  getLocation() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      area = pref.getString("area");
      double distanceInMeters = Geolocator.distanceBetween(19.877170331480794,
          75.37127692625344, pref.getDouble('lat'), pref.getDouble('lng'));
      distance = distanceInMeters / 1000;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Place order',
                style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
              ),
              backgroundColor: Color(0xFF202A36),
            ),
            key: _scaffoldkey,
            backgroundColor: Color(0xFF202A36),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.streetView,
                                  color: Color(0xFFF85547),
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Delivery at ',
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: area,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: (distance > 50) ? true : false,
                                      child: Text(
                                        'Dilivery is not available at your location.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GetLocationStatus(
                                                      nav: "place",
                                                    )));
                                      },
                                      child: Center(
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'OpenSans',
                                            letterSpacing: 1,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  color: Color(0xFFF85547),
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                distance > 50
                                    ? Text('Not available',
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ))
                                    : Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Delivery in ',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  distance.toInt().toString() +
                                                      ' mins',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Items you've added",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: CartMenu.names.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(),
                              height: 80,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            CartMenu.names[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'OpenSans',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "₹ " +
                                                              CartMenu
                                                                  .price[index]
                                                                  .toString() +
                                                              "  X" +
                                                              CartMenu
                                                                  .quant[index]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          (CartMenu.quant[CartMenu.names.indexOf(CartMenu.names[index])] == 1)
                                                                              ? CartMenu.names.remove(CartMenu.names[index])
                                                                              : CartMenu.quant[CartMenu.names.indexOf(CartMenu.names[index])] -= 1;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '-',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    CartMenu
                                                                        .quant[
                                                                            index]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFFF85547),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          CartMenu.quant[CartMenu
                                                                              .names
                                                                              .indexOf(CartMenu.names[index])] += 1;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '+',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Item Total",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ " + getItemTotal().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Delivery charges",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ " + getDeliveryCharges().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Grand Total",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "₹ " +
                                      (getItemTotal() + getDeliveryCharges())
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: (distance > 50)
                            ? () {
                                _showSnackbar(context,
                                    'We can only deliver in the 50 KM of radius of area.');
                              }
                            : () {
                                storeOrder();
                              },
                        borderRadius: BorderRadius.circular(18.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (distance > 50)
                                ? Colors.grey
                                : Color(0xFFF85547),
                          ),
                          child: Center(
                            child: Text(
                              'Place order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  int getItemTotal() {
    int total = 0;
    for (int i = 0; i < CartMenu.names.length; i++) {
      total += (CartMenu.price[i] * CartMenu.quant[i]);
    }
    return total;
  }

  int getDeliveryCharges() {
    int total = ((getItemTotal() / 100) * 8).toInt();
    return total;
  }

  _showSnackbar(BuildContext context, String error) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }

  storeOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('phone') == null) {
      showGeneralDialog(
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.sadTear,
                          color: Color(0xFFF85547),
                          size: 30,
                        ),
                        Text(
                          "It seems like your haven't register yet.\n Please register before order something.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Ink(
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
                              onTap: () {
                                CartMenu.cartClear();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (route) => false);
                              },
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          context: context,
          transitionDuration: Duration(milliseconds: 300),
          barrierDismissible: true,
          barrierLabel: '',
          pageBuilder: (context, animation1, animation2) {});
    } else {
      try {
        var res = await InternetAddress.lookup('google.com');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          try {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
            CollectionReference users = FirebaseFirestore.instance
                .collection('users')
                .doc(pref.getString('phone'))
                .collection('orders');
            for (int i = 0; i < CartMenu.names.length; i++) {
              await users.add({
                'name': CartMenu.names[i],
                'price': CartMenu.price[i],
                'quantity': CartMenu.quant[i],
              });
            }
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            showGeneralDialog(
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        content: Container(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.check,
                                color: Color(0xFFF85547),
                                size: 30,
                              ),
                              Text(
                                'Your order is placed successfully.\n Enjoy your meal soon.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Ink(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(
                                      0xFFF85547,
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      CartMenu.cartClear();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageScreen()),
                                          (route) => false);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                context: context,
                transitionDuration: Duration(milliseconds: 300),
                barrierDismissible: false,
                barrierLabel: '',
                pageBuilder: (context, animation1, animation2) {});
          } catch (e) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            _showSnackbar(context, 'Unable to place order');
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        _showSnackbar(context, 'No internet connection');
      }
    }
  }
}
