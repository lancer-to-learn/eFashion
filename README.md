# e_fashion

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


#Todo
<!-- dart run sqflite_common_ffi_web:setup -->
<!-- flutter run -d edge --web-renderer html -->

* adjust splash-creen later.
* adjust chat-screen in item detail
* cant add the first featured product (the runaway pre-loved...)

[{color: 4288423856, img:
https://res.cloudinary.com/natscloud/image/upload/v1684500861/eFashion/women_indoor_2_1_nirecb.jpg, vendor_id: 
k5ygrup4mDeYXKxMBblQoW0Qf5u2, tprice: 297, qty: 3, title: Short-Sleeve Scoop Neck Swing Dress}]

- Chức năng hiển thị 10 sản phẩm bán chạy nhất phân trang theo chiều ngang của trang (API và Code)


- Chức năng hiển thị tất cả sản phẩm theo từng danh mục sử dụng Lazy loading để load tiếp sản phẩm khi kéo xuống cuối trang (API và Code)


- Xây dựng chức năng theo dõi đơn hàng của người dùng gồm xem lại lịch sử mua hàng và theo dõi đơn hàng có xác định các trạng thái đơn hàng (1. đơn hàng mới, 2. Đã xác nhận đơn hàng (thủ công hoặc tự động 30 phút sau khi đơn đặt thành công), 3. Shop đang chuẩn bị hàng, 4. Đang giao hàng, 5. Đã giao thành công, 6. Hủy đơn hàng (chỉ cho phép hủy trước 30 phút sau khi đặt đơn, nếu đang ở bước 3 thì chuyển sang Gửi Yêu cầu hủy đơn cho shop)