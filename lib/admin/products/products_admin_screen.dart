import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/lists.dart';
import '../controller/product_admin_controller.dart';
import './add_product.dart';
import './edit_product.dart';
import './product_detail_admin.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../services/firestore_service.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import '../Components/appbar_widget.dart';

class Products_Admin_Screen extends StatelessWidget {
  const Products_Admin_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductAdminController());
    VxPopupMenuController show = VxPopupMenuController();
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await controller.getCategoryList();
            Get.to(() => const AddProduct());
          },
          child: const Icon(Icons.add),
        ),
        appBar: appbarWiget(products),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                        data.length,
                        (index) => ListTile(
                              onTap: () {
                                Get.to(() => ProductDetailAdmin(data: data[index],));
                              },
                              leading: Image.network(data[index]['p_imgs'][0],
                                  width: 100, height: 100, fit: BoxFit.cover),
                              title: boldText(
                                  text: "${data[index]['p_name']}", color: darkFontGrey),
                              subtitle: Row(
                                children: [
                                  normalText(text: "\$${data[index]['p_price']}", color: darkFontGrey),
                                  10.widthBox,
                                  boldText(
                                      text: data[index]['is_featured'] == true ? "Featured": '', color: Colors.green),
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
                                                  color: data[index]['featured_id'] == currentUser!.uid && i == 0 ? Colors.green : darkFontGrey,
                                                ),                                               
                                                10.widthBox,
                                                normalText(
                                                    text: data[index]['featured_id'] == currentUser!.uid && i == 0 ?
                                                      'Remove feature'
                                                      : popupMenuTitles[i],
                                                    color: darkFontGrey)
                                              ],
                                            ).onTap(() {
                                              switch (i) {
                                                case 0:
                                                  if (data[index]['is_featured'] == true) {
                                                    controller.removeFeature(data[index].id);
                                                    VxToast.show(context, msg: "Removed");
                                                    
                                                  } else {
                                                    controller.addFeature(data[index].id);
                                                    VxToast.show(context, msg: "Added");
                                                  }
                                                  show.hideMenu();
                                                  break;
                                                case 1:
                                                  Get.to(() => EditProduct(data: data[index]));
                                                  show.hideMenu();
                                                  break;
                                                case 2: 
                                                  controller.removeProduct(data[index].id);
                                                  show.hideMenu();
                                                  VxToast.show(context, msg: "Removed product");
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
