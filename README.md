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

- Chức năng hiển thị tất cả sản phẩm theo từng danh mục sử dụng Lazy loading để load tiếp sản phẩm khi kéo xuống cuối trang (API và Code)

- (1. đơn hàng mới, 2. Đã xác nhận đơn hàng (thủ công hoặc tự động 30 phút sau khi đơn đặt thành công), 3. Shop đang chuẩn bị hàng, 4. Đang giao hàng, 5. Đã giao thành công, 6. Hủy đơn hàng (chỉ cho phép hủy trước 30 phút sau khi đặt đơn, nếu đang ở bước 3 thì chuyển sang Gửi Yêu cầu hủy đơn cho shop)

- Xây dựng chức năng Bình luận, đánh giá sản phẩm đã mua thành công, mỗi lần đánh giá sẽ tặng mã giảm giá hoặc tặng điểm vào kho điểm tích lũy của mình cho lần mua sau (API + App).  

- sản phẩm tương tự, sản phẩm đã xem và đếm số khách mua, khách bình luận trên sản phẩm đó (API+APP)

- Xây dựng chức năng phiếu giảm giá, khuyến mãi để áp vào sản phẩm khi khách mua hàng, kho điểm tích lũy để mua hàng từ điểm tích lũy.