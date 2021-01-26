import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/models/cart.dart';
import 'package:food/models/cart_menu.dart';
import 'package:food/screens/place_order.dart';
import 'package:food/screens/search.dart';
import 'package:provider/provider.dart';

class MenuViewerScreen extends StatefulWidget {
  String category;

  MenuViewerScreen({Key key, @required this.category}) : super(key: key);
  @override
  _MenuViewerState createState() => _MenuViewerState();
}

class _MenuViewerState extends State<MenuViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order now',
          style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 2),
        ),
        actions: [
          OpenContainer(
            openColor: Color(0xFF202A36),
            closedColor: Color(0xFF202A36),
            closedBuilder: (context, open) {
              return IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: open,
              );
            },
            openBuilder: (context, close) {
              return ChangeNotifierProvider(
                  create: (context) => Cart(), child: SearchScreen());
            },
          ),
        ],
        backgroundColor: Color(0xFF202A36),
      ),
      backgroundColor: Color(0xFF202A36),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('menu')
                    .where('category', isEqualTo: widget.category)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: FractionallySizedBox(
                      heightFactor: 0.001,
                      widthFactor: 0.2,
                      child: LinearProgressIndicator(),
                    ));
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: snapshot.data.docs.map((documents) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    documents['image'],
                                    fit: BoxFit.fill,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : LinearProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      documents['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
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
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 15,
                                                color: Color(0xFFF85547),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                documents['rating'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                              Text(
                                                "/5",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "₹ " +
                                                        documents['price']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Consumer<Cart>(
                                                  builder:
                                                      (context, data, child) {
                                                    return Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 25,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Container(
                                                          height: 25,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  Colors.white),
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              data.updateCart(
                                                                  documents[
                                                                      'price'],
                                                                  documents[
                                                                      'name']);
                                                              CartMenu.updateCart(
                                                                  documents[
                                                                      'price'],
                                                                  documents[
                                                                      'name']);
                                                            },
                                                            color: Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Center(
                                                              child: data.names
                                                                      .contains(
                                                                          documents[
                                                                              'name'])
                                                                  ? Text(
                                                                      'ADDED',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      'ADD +',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<Cart>(
        builder: (context, data, child) {
          return data.itemCount == 0
              ? Container()
              : OpenContainer(
                  openColor: Color(0xFF202A36),
                  closedColor: Color(0xFF202A36),
                  closedBuilder: (context, close) {
                    return Container(
                      margin: EdgeInsets.only(left: 30),
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xFFF85547),
                        onPressed: close,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.itemCount.toString() + ' ITEM',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '₹ ' + data.price.toString(),
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' Plus taxes',
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'View Cart',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.caretRight,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  openBuilder: (context, open) {
                    return ChangeNotifierProvider(
                        create: (context) => Cart(), child: PlaceOrderScreen());
                  },
                );
        },
      ),
    );
  }

  filterResults() {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    CartMenu.cartClear();
  }
}
