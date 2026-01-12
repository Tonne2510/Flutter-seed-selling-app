import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/provider/cart_provider.dart';
import 'package:ecommerce_app_firebase/views/screens/user_info_screen.dart';
import 'package:ecommerce_app_firebase/views/screens/order_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';
import '../../models/order_model.dart' as order_models;
import '../../models/resources.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.receipt_long),
          backgroundColor: Colors.red,
          onPressed: () async {
            DocumentSnapshot userDoc = await FireBaseStoreHelper.db
                .collection('users')
                .doc(currentUserEmail)
                .get();

            if (!userDoc.exists ||
                !userDoc.data().toString().contains('fullName')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Vui lòng nhập thông tin cá nhân trước khi đặt hàng!'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfoScreen(),
                  ),
                );
              });
              return;
            }

            final cartSnapshot =
                await FireBaseStoreHelper.db.collection("cartProduct").get();

            if (cartSnapshot.docs.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Giỏ hàng trống!'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }

            int totalPrice = 0;
            List<order_models.OrderItem> items = [];

            for (var doc in cartSnapshot.docs) {
              int quantity = doc['quantity'] ?? 1;
              int price = doc['price'] ?? 0;
              totalPrice += (quantity * price);

              items.add(
                order_models.OrderItem(
                  productName: doc['name'] ?? '',
                  quantity: quantity,
                  price: price,
                  image: doc['image'] ?? '',
                ),
              );
            }

            String orderId =
                FireBaseStoreHelper.db.collection('orders').doc().id;

            order_models.ShopOrder newOrder = order_models.ShopOrder(
              id: orderId,
              userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
              userEmail: currentUserEmail ?? 'unknown@email.com',
              items: items,
              totalPrice: totalPrice,
              status: 'chờ xác nhận',
              createdAt: DateTime.now(),
            );

            Map<String, dynamic> userInfo =
                userDoc.data() as Map<String, dynamic>;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderConfirmationScreen(
                  order: newOrder,
                  userInfo: userInfo,
                ),
              ),
            );
          },
          label: const Text(
            'Đặt Hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.alata(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FireBaseStoreHelper.db.collection("cartProduct").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allFav =
                snapshot.data!.docs;
            if (allFav.isNotEmpty) {
              int sum = 0, qut = 0;
              for (var e in allFav) {
                qut += (e['quantity'] as int?) ?? 0;
                sum += ((e['quantity'] as int?) ?? 0) *
                    ((e['price'] as int?) ?? 0);
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: allFav.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, i) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Get.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade200,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                allFav[i]['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allFav[i]['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    allFav[i]['category'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${allFav[i]['price']} ₫',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      await Provider.of<CartController>(
                                        context,
                                        listen: false,
                                      ).deleteFromCart(Uid: allFav[i]['Uid']);
                                    },
                                    icon: const Icon(Icons.close, size: 16),
                                    color: Colors.red,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<CartController>(
                                          context,
                                          listen: false,
                                        ).decrement(e: allFav[i]);
                                      },
                                      child: const Icon(Icons.remove, size: 16),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${allFav[i]['quantity']}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<CartController>(
                                          context,
                                          listen: false,
                                        ).increment(e: allFav[i]);
                                      },
                                      child: const Icon(Icons.add, size: 16),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng: $sum ₫',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Số lượng: $qut sản phẩm',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Icon(
                Icons.add_shopping_cart,
                size: 200,
                color: Colors.grey.shade300,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        },
      ),
    );
  }
}
