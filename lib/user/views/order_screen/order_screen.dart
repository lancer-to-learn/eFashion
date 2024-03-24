import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import '../../../services/firestore_service.dart';
import 'order_details.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title:
              "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
        ),
        body: StreamBuilder(
            stream: FirestoreServices.getAllOrders(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return "No orders yet!".text.color(darkFontGrey).makeCentered();
              } else {
                var data = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: "${index + 1}"
                          .text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .xl
                          .make(),
                      title: DateTime.fromMicrosecondsSinceEpoch(
                              data[index]['order_date'].microsecondsSinceEpoch)
                          .toString()
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                      subtitle: "Total price: \$${data[index]['total_amount']}"
                          .toString()
                          .text
                          .fontFamily(bold)
                          .make(),
                      trailing: IconButton(
                          onPressed: () {
                            Get.to(() => OrdersDetails(data: data[index]));
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded,
                              color: darkFontGrey)),
                    );
                  },
                );
              }
            }));
  }
}
