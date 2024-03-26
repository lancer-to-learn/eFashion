import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/admin/components/appbar_widget.dart';
import 'package:e_fashion/admin/controller/coupon_admin_controller.dart';
import 'package:e_fashion/admin/setting/coupon/add_coupon_screen.dart';
import 'package:e_fashion/admin/setting/coupon/edit_coupon.dart';
import 'package:e_fashion/consts/lists.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../services/firestore_service.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/common/widgets/text_style.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CouponAdminController());
    // controller.reset();
    VxPopupMenuController show = VxPopupMenuController();
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Get.to(() => const AddCoupon());
          },
          child: const Icon(Icons.add),
        ),
        appBar: appbarWiget("Coupons"),
        body: StreamBuilder(
            stream: FirestoreServices.getCouponsByVendor(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingIndicator(),
                );
              } else {
                var data = snapshot.data!.docs;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                        data.length,
                        (index) => ListTile(
                              onTap: () {
                                // Get.to(() => ProductDetailAdmin(data: data[index],));
                              },
                              leading: Image.network(couponImg,
                                  width: 100, height: 100, fit: BoxFit.cover),
                              title: boldText(
                                  text: "${data[index]['name']}", color: darkFontGrey),
                              subtitle: Row(
                                children: [
                                  normalText(text: "\$${data[index]['value']}", color: darkFontGrey),
                                  10.widthBox,
                                  boldText(
                                      text: data[index]['activate'] == true ? "Activated": '', color: Colors.green),
                                ],
                              ),
                              trailing: VxPopupMenu(
                                arrowSize: 0.0,
                                controller: show,
                                menuBuilder: () => Column(
                                  children: List.generate(
                                      popupMenuTitles.length,
                                      (i) => Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  popupMenuIcons[i],
                                                  color: data[index]['activated'] == true && i == 0 ? Colors.green : darkFontGrey,
                                                ),                                               
                                                10.widthBox,
                                                normalText(
                                                    text: data[index]['activated'] == true && i == 0 ?
                                                      'Remove feature'
                                                      : popupMenuTitles[i],
                                                    color: darkFontGrey)
                                              ],
                                            ).onTap(() {
                                              switch (i) {
                                                case 0:
                                                  if (data[index]['activated'] == true) {
                                                    controller.removeFeature(data[index].id);
                                                    VxToast.show(context, msg: "Removed!");
                                                    
                                                  } else {
                                                    controller.addFeature(data[index].id);
                                                    VxToast.show(context, msg: "Activated!");
                                                  }
                                                  show.hideMenu();
                                                  break;
                                                case 1:
                                                  Get.to(() => EditCoupon(data: data[index]));
                                                  show.hideMenu();
                                                  break;
                                                case 2: 
                                                  controller.removeProduct(data[index].id);
                                                  show.hideMenu();
                                                  VxToast.show(context, msg: "Removed coupon!");
                                                  break;
                                                default:
                                              }
                                            }),
                                          )),
                                ).box.white.width(200).make(),
                                clickType: VxClickType.singleClick,
                                child: const Icon(Icons.more_vert_rounded),
                              ),
                            )),
                  ),
                ));
              }
            }));
  }
}
