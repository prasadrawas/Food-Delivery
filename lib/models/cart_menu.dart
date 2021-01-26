import 'package:flutter/foundation.dart';

class CartMenu extends ChangeNotifier {
  static List<String> names = [];
  static List<int> price = [];
  static List<int> quant = [];

  static updateCart(int p, String n) {
    if (!names.contains(n)) {
      names.add(n);
      price.add(p);
      quant.add(1);
    } else {
      quant[names.indexOf(n)] = quant[names.indexOf(n)] + 1;
    }
  }

  static cartClear() {
    names = [];
    price = [];
    quant = [];
  }
}
