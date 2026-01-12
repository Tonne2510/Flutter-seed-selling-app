import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseStoreHelper {
  FireBaseStoreHelper._();

  static final FireBaseStoreHelper fireBaseStoreHelper =
      FireBaseStoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insert({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection('counter').doc('CounterKeeper').get();
    int id = k['id'];
    int len = k['lenght'];
    await db.collection("product").doc("${++id}").set(data);
    db.collection("product").doc("$id").update({"Uid": id});
    db
        .collection("counter")
        .doc("CounterKeeper")
        .update({'id': id, 'lenght': ++len});
  }

  Future<void> update({required Map<String, dynamic> data}) async {
    String id = data['Uid'].toString();
    db.collection('product').doc(id).set(data);
  }

  Delete({required int Uid}) async {
    String id = Uid.toString();
    await db.collection("product").doc(id).delete();

    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection("counter").doc("CounterKeeper").get();

    int length = k['lenght'];

    await db
        .collection("counter")
        .doc("CounterKeeper")
        .update({"lenght": --length});
  }

  Future<void> cartInsert({required Map<String, dynamic> data}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> k =
          await db.collection('cartCounter').doc('cartCounterKeeper').get();

      if (!k.exists) {
        // Nếu chưa tồn tại, tạo mới
        await db
            .collection('cartCounter')
            .doc('cartCounterKeeper')
            .set({'id': 0, 'lenght': 0});
      }

      int id = k.exists ? (k['id'] ?? 0) : 0;
      int len = k.exists ? (k['lenght'] ?? 0) : 0;

      await db.collection("cartProduct").doc("${++id}").set(data);
      await db.collection("cartProduct").doc("$id").update({"Uid": id});
      await db
          .collection("cartCounter")
          .doc("cartCounterKeeper")
          .update({'id': id, 'lenght': ++len});
    } catch (e) {
      print('Error in cartInsert: $e');
      // Fallback: Thêm trực tiếp vào cartProduct
      int randomId = DateTime.now().millisecondsSinceEpoch;
      await db.collection("cartProduct").doc("$randomId").set({
        ...data,
        'Uid': randomId,
      });
    }
  }

  Future<void> cartUpdate({required Map<String, dynamic> data}) async {
    try {
      String id = data['Uid'].toString();
      await db.collection('cartProduct').doc(id).set(data);
    } catch (e) {
      print('Error in cartUpdate: $e');
    }
  }

  cartDelete({required int Uid}) async {
    try {
      String id = Uid.toString();
      await db.collection("cartProduct").doc(id).delete();

      DocumentSnapshot<Map<String, dynamic>> k =
          await db.collection("cartCounter").doc("cartCounterKeeper").get();

      int length = k['lenght'] ?? 1;

      await db
          .collection("cartCounter")
          .doc("cartCounterKeeper")
          .update({"lenght": --length});
    } catch (e) {
      print('Error in cartDelete: $e');
    }
  }

  Future<void> imageInsert({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> k =
        await db.collection('imgCounter').doc('imageCounterKeeper').get();
    int id = k['id'];
    int len = k['lenght'];
    await db.collection("UserImage").doc("${++id}").set(data);
    db.collection("UserImage").doc("$id").update({"Uid": id});
    db
        .collection("imgCounter")
        .doc("imageCounterKeeper")
        .update({'id': id, 'lenght': ++len});
  }
}
