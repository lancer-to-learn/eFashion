
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/order_admin_controller.dart';
import '../components/appbar_widget.dart';
import '../components/dashboard_button.dart';
import '../products/product_detail_admin.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';

import '../../../services/firestore_service.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';

class Home_Admin_Screen extends StatelessWidget {
  const Home_Admin_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    
    // TODO: implement build
    return Scaffold(
      appBar: appbarWiget(dashboard),
      body: StreamBuilder(
         stream: FirestoreServices.getProductsByVendor(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingIndicator(),
                );
              } else {
                var data = snapshot.data!.docs;
                data = data.sortedBy((a, b) => a['p_wishlist'].length.compareTo(b['p_wishlist'].length));
                return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dashboardButton(context, title: products, count: "${data.length}", icon: icWholeSale),
                dashboardButton(context, title: aorders, count: "2", icon: icOrders),
              ],
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dashboardButton(context, title: rating, count: "60", icon: icBrands),
                dashboardButton(context, title: totalSales, count: "15", icon: icOrder),
              ],
            ),
            10.heightBox,
            const Divider(),
            10.heightBox,
            boldText(text: "Popular Products", color: darkFontGrey, size: 16.0),
            20.heightBox,
            ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(data.length, (index) => ListTile(
                onTap: () {
                  Get.to(() => ProductDetailAdmin(data: data[index]));
                },
                leading: Image.network(data[index]['p_imgs'][0], width: 50, height: 50, fit: BoxFit.cover),
                title: boldText(text: "${data[index]['p_name']}", color: darkFontGrey),
                subtitle: normalText(text: "\$ ${data[index]['p_price']}", color: darkFontGrey),
              )
              ),
            )
          ],
        ),)
        );}           }
      ),
    );
  }
}