import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_firestore_helper.dart';
import 'package:ecommerce_app_firebase/models/provider/cart_model.dart';
import 'package:flutter/material.dart';

import '../../models/product_model.dart';

class CartController extends ChangeNotifier {
  //add to cart
  CartModel cartModel = CartModel(i: 1);

  Future<void> addToCart({required products e}) async {
    try {
      Map<String, dynamic> temp = {
        'id': e.id,
        'name': e.name,
        'category': e.category,
        'description': e.description,
        'image': e.image,
        'quantity': e.quantity,
        'price': e.price,
      };
      await FireBaseStoreHelper.fireBaseStoreHelper.cartInsert(data: temp);
      print('✅ Thêm vào giỏ thành công!');
      notifyListeners();
    } catch (e) {
      print('❌ Lỗi thêm vào giỏ: $e');
    }
  }

  deleteFromCart({required int Uid}) async {
    try {
      await FireBaseStoreHelper.fireBaseStoreHelper.cartDelete(Uid: Uid);
      print('✅ Xóa khỏi giỏ thành công!');
      notifyListeners();
    } catch (e) {
      print('❌ Lỗi xóa khỏi giỏ: $e');
    }
  }

  increment({required QueryDocumentSnapshot<Map<String, dynamic>> e}) async {
    try {
      cartModel.i = e['quantity'];
      ++cartModel.i;
      int Uid = e['Uid'];
      print(cartModel.i);
      Map<String, dynamic> temp = {
        'Uid': Uid,
        'id': e['id'],
        'name': e['name'],
        'category': e['category'],
        'description': e['description'],
        'image': e['image'],
        'quantity': cartModel.i,
        'price': e['price'],
      };
      await FireBaseStoreHelper.fireBaseStoreHelper.cartUpdate(data: temp);
      notifyListeners();
    } catch (e) {
      print('❌ Lỗi tăng số lượng: $e');
    }
  }

  decrement({required QueryDocumentSnapshot<Map<String, dynamic>> e}) async {
    try {
      cartModel.i = e['quantity'];
      if (e['quantity'] == 1) {
        await deleteFromCart(Uid: e['Uid']);
      } else {
        --cartModel.i;
        int Uid = e['Uid'];
        print(cartModel.i);
        Map<String, dynamic> temp = {
          'Uid': Uid,
          'id': e['id'],
          'name': e['name'],
          'category': e['category'],
          'description': e['description'],
          'image': e['image'],
          'quantity': cartModel.i,
          'price': e['price'],
        };
        await FireBaseStoreHelper.fireBaseStoreHelper.cartUpdate(data: temp);
      }
      notifyListeners();
    } catch (e) {
      print('❌ Lỗi giảm số lượng: $e');
    }
  }
}
