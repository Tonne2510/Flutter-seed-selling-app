class ShopOrder {
  final String id;
  final String userId;
  final String userEmail;
  final List<OrderItem> items;
  final int totalPrice;
  final String
      status; // 'chờ xác nhận', 'đã xác nhận', 'đang giao hàng', 'đã giao hàng'
  final DateTime createdAt;
  final String? notes;
  final Map<String, dynamic>? userInfo; // Thông tin user: tên, sdt, địa chỉ

  ShopOrder({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.notes,
    this.userInfo,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
      'notes': notes,
      'userInfo': userInfo,
    };
  }

  // Create from Map
  factory ShopOrder.fromMap(Map<String, dynamic> map, String docId) {
    return ShopOrder(
      id: docId,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      items: List<OrderItem>.from(
        (map['items'] as List)
            .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
            .toList(),
      ),
      totalPrice: map['totalPrice'] ?? 0,
      status: map['status'] ?? 'chờ xác nhận',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      notes: map['notes'],
      userInfo: map['userInfo'] as Map<String, dynamic>?,
    );
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final int price;
  final String image;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: map['price'] ?? 0,
      image: map['image'] ?? '',
    );
  }
}
