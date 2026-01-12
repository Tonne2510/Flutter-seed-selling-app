import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/controller/helper_classes/firebase_firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import '../../models/resources.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    Reference refImg;
    String ImageUrl = '';
    getimg() async {
      ImagePicker imagePicker = ImagePicker();
      XFile? myImage = await imagePicker.pickImage(source: ImageSource.gallery);

      String tempFile = person ?? myImage!.path;
      //initialize FirebaseStorage
      Reference reference = FirebaseStorage.instance.ref();
      //create folder in FirebaseStorage
      Reference refRoot = reference.child('clients');
      // now upload image in Folder
      refImg = refRoot.child(tempFile);
      //putting file in image
      refImg.putFile(File(myImage!.path));
      print('img_uploded');
      ImageUrl = await refImg.getDownloadURL();
      Map<String, dynamic> tempp = {
        'name': tempFile,
        'image': ImageUrl,
      };
      FireBaseStoreHelper.fireBaseStoreHelper.imageInsert(data: tempp);
    }

    return Drawer(
      child: Builder(builder: (context) {
        return Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.red.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: FireBaseStoreHelper.db
                          .collection("UserImage")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo/user.png'),
                                radius: 50,
                                backgroundColor: Colors.blue,
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                      Colors.red.shade300,
                                    )),
                                    onPressed: getimg,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    )),
                              ),
                            ],
                          );
                        } else if (snapshot.hasData) {
                          QuerySnapshot<Map<String, dynamic>>? favourite =
                              snapshot.data;
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              imgs = favourite!.docs;
                          if (imgs.isEmpty) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/logo/user.png'),
                                  radius: 50,
                                  backgroundColor: Colors.blue,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                        Colors.red.shade300,
                                      )),
                                      onPressed: getimg,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      )),
                                ),
                              ],
                            );
                          } else {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage('${imgs[0]['image']}'),
                                  radius: 50,
                                  backgroundColor: Colors.blue,
                                ),
                              ],
                            );
                          }
                        }
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/logo/user.png'),
                              radius: 50,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                    Colors.red.shade300,
                                  )),
                                  onPressed: getimg,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            currentUserEmail ?? 'User',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (person == null) ? '' : '$person',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                (userRole == 'admin') ? '👤 Admin' : 'User',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: (userRole == 'admin')
                                        ? Colors.yellow.shade700
                                        : Colors.white70),
                              ),
                              if (userRole == 'admin')
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '⭐',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // Admin Menu
                        if (userRole == 'admin')
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.amber.shade600,
                                  width: 4,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, 'adminOrders');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_checkout,
                                          size: 20,
                                          color: Colors.amber.shade700,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Quản lý đơn hàng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.amber.shade800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, 'adminStats');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.bar_chart,
                                          size: 20,
                                          color: Colors.amber.shade700,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Thống kê bán hàng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.amber.shade800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, 'adminUsers');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 20,
                                          color: Colors.amber.shade700,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Quản lý người dùng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.amber.shade800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // User Menu (chỉ hiển thị khi không phải admin)
                        if (userRole != 'admin')
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'favouriteScreen');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.favorite, size: 20),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Favourite',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (userRole != 'admin')
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'customerInfo');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.person, size: 20),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Users',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (userRole != 'admin')
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.settings, size: 20),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (userRole != 'admin')
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'userOrders');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.shopping_cart, size: 20),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Orders',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (userRole != 'admin')
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.help, size: 20),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'Help',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        // Logout - Hiển thị cho cả admin và user
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Đăng xuất'),
                                    content: const Text(
                                        'Bạn có chắc muốn đăng xuất?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          person = null;
                                          currentUserEmail = null;
                                          userRole = 'user';
                                          Navigator.pushReplacementNamed(
                                              context, 'logSignPage');
                                        },
                                        child: const Text('Đăng xuất'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.logout,
                                    size: 20, color: Colors.red.shade600),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'Đăng xuất',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      }),
    );
  }
}
