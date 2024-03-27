import 'package:e_fashion/common/widgets/exit_dialog.dart';
import 'package:e_fashion/common/widgets/rate_dialog.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/controllers/cart_controller.dart';
import '../../../common/widgets/our_button.dart';
import 'components/order_place_details.dart';
import 'components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Order Details"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                orderStatus(
                    color: redColor,
                    icon: Icons.done,
                    title: "Placed",
                    showDone: data['order_placed']),
                orderStatus(
                    color: Colors.blue,
                    icon: Icons.thumb_up,
                    title: "Confirmed",
                    showDone: data['order_confirmed']),
                orderStatus(
                    color: Colors.amber.shade400,
                    icon: Icons.add_card_outlined,
                    title: "Preparing",
                    showDone: data['order_on_prepared']
                        ? data['order_on_prepared']
                        : false),
                orderStatus(
                    color: Colors.yellow,
                    icon: Icons.car_crash,
                    title: "On Delivery",
                    showDone: data['order_on_delivery']),
                orderStatus(
                    color: Colors.purple,
                    icon: Icons.done_all_rounded,
                    title: "Delivered",
                    showDone: data['order_delivered']),
                orderStatus(
                    color: Colors.black,
                    icon: Icons.cancel_presentation,
                    title: "Cancelled",
                    showDone: data['order_cancelled']),
                const Divider(),
                10.heightBox,
                Column(
                  children: [
                    orderPlaceDetails(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetails(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((data['order_date'].toDate())),
                      d2: data['payment_method'],
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetails(
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
                              "Shipping Address"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),
                              "${data['order_by_name']}".text.make(),
                              "${data['order_by_email']}".text.make(),
                              "${data['order_by_address']}".text.make(),
                              "${data['order_by_city']}".text.make(),
                              "${data['order_by_phone']}".text.make(),
                              "${data['order_by_postalcode']}".text.make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Total Amount".text.fontFamily(semibold).make(),
                                "${data['total_amount']}"
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .make()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ).box.outerShadowMd.white.make(),
                const Divider(),
                10.heightBox,
                "Ordered Product"
                    .text
                    .size(16)
                    .color(darkFontGrey)
                    .fontFamily(semibold)
                    .makeCentered(),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(data['orders'].length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                          title1: data['orders'][index]['title'],
                          title2: data['orders'][index]['tprice'],
                          d1: "${data['orders'][index]['qty']}x",
                          d2: "Non-refundable",
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                  width: 30,
                                  height: 20,
                                  color: Color(data['orders'][index]['color'])),
                            ),
                            "Do you like this product?"
                                .text
                                .color(redColor)
                                .make()
                                .onTap(() async {
                              if (data['order_delivered']) {
                                await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) =>
                                        rateDialog(context, data['orders'][index]['P_id']));
                              } else {
                                VxToast.show(context,
                                    msg: "Product has not yet been delivered");
                              }
                            }),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                )
                    .box
                    .outerShadowMd
                    .white
                    .margin(const EdgeInsets.only(bottom: 4))
                    .make(),
                20.heightBox,
                "Cancell order is available until ${CartController().calculateOrderExpiredTime(data["order_date"])}"
                    .text
                    .size(16)
                    .color(darkFontGrey)
                    .fontFamily(semibold)
                    .makeCentered(),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ourButton(
                      color: redColor,
                      onPress: () async {
                        if (await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => exitDialog(context,
                                    "Are you sure you want to cancell this order?")) ==
                            true) {
                          try {
                            var res =
                                await FirestoreServices.cancellOrder(data);
                            VxToast.show(context, msg: res);
                          } catch (e) {
                            print(e.toString());
                            VxToast.show(context, msg: "Try again later!");
                          }
                        }
                      },
                      textColor: whiteColor,
                      title: "Cancell order"),
                ),
              ],
            ),
          ),
        ));
  }
}
