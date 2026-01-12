import 'package:flutter/material.dart';
import '../../controller/helper_classes/firebase_firestore_helper.dart';
import '../../models/order_model.dart' as order_models;
import '../../models/resources.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final order_models.ShopOrder order;
  final Map<String, dynamic> userInfo;

  const OrderConfirmationScreen({
    Key? key,
    required this.order,
    required this.userInfo,
  }) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool _isLoading = false;

  // Xác nhận đơn hàng và lưu vào Firestore
  Future<void> _confirmOrder() async {
    setState(() => _isLoading = true);

    try {
      // Cập nhật userInfo vào order
      order_models.ShopOrder finalOrder = order_models.ShopOrder(
        id: widget.order.id,
        userId: widget.order.userId,
        userEmail: widget.order.userEmail,
        items: widget.order.items,
        totalPrice: widget.order.totalPrice,
        status: 'chờ xác nhận',
        createdAt: widget.order.createdAt,
        notes: widget.order.notes,
        userInfo: widget.userInfo,
      );

      // Lưu đơn hàng vào Firestore
      await FireBaseStoreHelper.db
          .collection('orders')
          .doc(widget.order.id)
          .set(finalOrder.toMap());

      // Xóa giỏ hàng
      final cartSnapshot =
          await FireBaseStoreHelper.db.collection("cartProduct").get();
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt hàng thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Quay về home
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'homePage',
            (route) => false,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Xác Nhận Đơn Hàng'),
          backgroundColor: Colors.red.shade800,
          leading: _isLoading ? const SizedBox() : null,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin khách hàng
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.red.shade800,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Thông Tin Khách Hàng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Họ và tên:',
                          widget.userInfo['fullName'] ?? 'Chưa nhập',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Số điện thoại:',
                          widget.userInfo['phoneNumber'] ?? 'Chưa nhập',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Email:',
                          currentUserEmail ?? 'Chưa nhập',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Địa chỉ:',
                          widget.userInfo['address'] ?? 'Chưa nhập',
                          isMultiline: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Danh sách sản phẩm
                const Text(
                  'Danh Sách Sản Phẩm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.order.items.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hình ảnh sản phẩm
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Thông tin sản phẩm
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Số lượng: ${item.quantity}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Giá: ${_formatPrice(item.price)} đ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tổng tiền item
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_formatPrice(item.price * item.quantity)} đ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),

                // Tổng cộng
                Card(
                  elevation: 2,
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng Cộng:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_formatPrice(widget.order.totalPrice)} đ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Nút xác nhận
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Xác Nhận Đặt Hàng',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: isMultiline ? 3 : 1,
          ),
        ),
      ],
    );
  }
}
