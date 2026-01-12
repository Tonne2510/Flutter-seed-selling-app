import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controller/helper_classes/firebase_firestore_helper.dart';
import '../../models/product_model.dart';
import '../../models/resources.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    isAdmin = currentUserEmail == 'admin@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    products e = ModalRoute.of(context)!.settings.arguments as products;
    return Scaffold(
      backgroundColor:
          (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 22, top: 10, bottom: 10, right: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
        ),
        foregroundColor:
            (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
        backgroundColor:
            (Get.isDarkMode) ? Colors.red.shade200 : Colors.red.shade100,
        elevation: 0,
        bottomOpacity: 0.0,
        scrolledUnderElevation: 0,
        actions: [
          const SizedBox(width: 10),
          Padding(
            padding:
                const EdgeInsets.only(left: 26, top: 10, bottom: 10, right: 22),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'CartScreen');
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 6)
        ],
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: (Get.isDarkMode) ? Colors.grey.shade900 : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-2, -3),
                      blurRadius: 12)
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 80),
                      const Spacer(flex: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 33),
                            ),
                            const Spacer(),
                            Text(
                              '${e.price.toString()} ₫',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 33,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          e.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          thickness: 1.7,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '⭐️ 5.4',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '⏰ 10-20 hours',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40),
                        child: Text(
                          e.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            wordSpacing: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      // Buttons Section
                      if (isAdmin)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildDisabledButton(
                                    'Không dùng', Icons.lock),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: _buildDisabledButton(
                                    'Không dùng', Icons.lock),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildFavoriteButton(e),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: _buildCartButton(e),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -150),
                    child: Transform.scale(
                      scale: 0.6,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                          tag: e.name,
                          child: Transform.translate(
                            offset: const Offset(0, -250),
                            child: Image.asset(e.image),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledButton(String label, IconData icon) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey.shade400),
      ),
      onPressed: null,
      child: Container(
        alignment: Alignment.center,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(products e) {
    return StreamBuilder(
      stream: FireBaseStoreHelper.db
          .collection('favourite')
          .where('name', isEqualTo: e.name)
          .where('category', isEqualTo: e.category)
          .where('userEmail', isEqualTo: currentUserEmail)
          .snapshots(),
      builder: (context, snapshot) {
        bool isFavourite = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        if (isFavourite) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade400),
            ),
            onPressed: null,
            child: Container(
              alignment: Alignment.center,
              height: 70,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'Đã yêu thích',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.pink.shade400),
            ),
            onPressed: () async {
              Map<String, dynamic> addFav = {
                'name': e.name,
                'category': e.category,
                'price': e.price,
                'image': e.image,
                'id': e.id,
                'userEmail': currentUserEmail,
              };
              await FireBaseStoreHelper.db.collection('favourite').add(addFav);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                    content: Text('Thêm vào yêu thích'),
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 70,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'Yêu thích',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCartButton(products e) {
    return StreamBuilder(
      stream: FireBaseStoreHelper.db.collection("cartProduct").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildAddToCartButton(e);
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildAddToCartButton(e);
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> cartItems =
            snapshot.data!.docs;
        bool isInCart = cartItems.any((item) => item['name'] == e.name);

        if (isInCart) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green.shade500),
            ),
            onPressed: null,
            child: Container(
              alignment: Alignment.center,
              height: 70,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'Có rồi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildAddToCartButton(e);
      },
    );
  }

  Widget _buildAddToCartButton(products e) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.red.shade500),
      ),
      onPressed: () {
        Provider.of<CartController>(context, listen: false).addToCart(e: e);
      },
      child: Container(
        alignment: Alignment.center,
        height: 70,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Thêm giỏ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
