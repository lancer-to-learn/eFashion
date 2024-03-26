
import '../controller/order_admin_controller.dart';
// import 'package:e_fashion/views/profile_screen/edit_profile.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../components/order_place.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetailAdmin extends StatefulWidget {
  final dynamic data;
  const OrderDetailAdmin({super.key, this.data});
  @override
  State<OrderDetailAdmin> createState() => _OrderDetailAdminState();
}

class _OrderDetailAdminState extends State<OrderDetailAdmin> {
  var controller = Get.find<OrderController>();
  num total = 0;
  // var controller = Get.put(OrderController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data.id);
    total = controller.getOrders(widget.data);
    // controller.orders = widget.data['orders'][0];
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.onDelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() =>
      Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkFontGrey),
          onPressed: () {
            Get.back();
          }, 
        ),
        title: boldText(text: "Order details", size: 16.0, color: fontGrey),
      ),
      bottomNavigationBar: Visibility(
        visible: !controller.confirmed.value,
        child: SizedBox(
        height: 60,
        width: context.screenWidth,
        child: ourButton(color: Colors.green, onPress: () {
          controller.confirmed(true);
          controller.changeStatus(title: "order_confirmed", status: true, docID: widget.data.id);
        }, title: "Confirm Order"),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //order delivery section
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(text: "Order Status", color: fontGrey, size: 16.0),
                    SwitchListTile(
                      activeColor: Colors.green,
                      value: true,
                      onChanged: (value) {
                        
                      },
                      title: boldText(text: "Placed", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: Colors.green,
                      value: controller.confirmed.value,
                      onChanged: (value) {
                      },
                      title: boldText(text: "Confirmed", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: Colors.green,
                      value: controller.onDelivery.value,
                      onChanged: (value) {
                        controller.onDelivery.value = value;
                        controller.changeStatus(title: "order_on_delivery", status: value, docID: widget.data.id);
                      },
                      title: boldText(text: "On Delivery", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: Colors.green,
                      value: controller.delivered.value,
                      onChanged: (value) {
                        controller.delivered.value = value;
                        controller.changeStatus(title: "order_delivered", status: value, docID: widget.data.id);
                      },
                      title: boldText(text: "Delivered", color: fontGrey),
                    )
                  ],
                ).box.padding(const EdgeInsets.all(8.0)).outerShadowMd.white.border(color: lightGrey).roundedSM.make(),
                ),

                //order detail section
                Column(
                  children: [
                    orderPlaceDetailsAdmin(
                      d1: "${widget.data['order_code']}",
                      d2: "${widget.data['shipping_method']}",
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetailsAdmin(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((widget.data['order_date'].toDate())),
                      d2: "${widget.data['payment_method']}",
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetailsAdmin(
                      d1: "Unpaid",
                      d2: "Order Placed",
                      title1: "Payment Status",
                      title2: "Delevery Status",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // "Shipping Address"
                              //     .text
                              //     .fontFamily(semibold)
                              //     .make(),
                              boldText(text: "Shipping Address", color: darkFontGrey),
                              // "${widget.data['order_by_name']}".text.make(),
                              // "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_address']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_phone']}".text.make(),
                              "${widget.data['order_by_postalcode']}".text.make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(text: "Total Amount", color: darkFontGrey),
                                boldText(text: "\$ ${total.toString()}", color: redColor, size: 16.0)
                                // "Total Amount".text.fontFamily(semibold).make(),
                                // "${widget.data['total_amount']}"
                                //     .text
                                //     .color(redColor)
                                //     .fontFamily(bold)
                                //     .make()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ).box.outerShadowMd.white.border(color: lightGrey).roundedSM.make(),
                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.orders.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetailsAdmin(
                          title1: "${controller.orders[index]['title']}",
                          title2: "${controller.orders[index]['tprice']}",
                          d1: "${controller.orders[index]['qty']}x",
                          d2: "Refundable",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                              width: 30,
                              height: 20,
                              color: darkFontGrey,
                          )
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ).box.outerShadowMd.white.margin(const EdgeInsets.only(bottom: 4)).make(),
                20.heightBox,
                
              ],
            ),
          ),
      ),
    ));
  }

}
  
  
  