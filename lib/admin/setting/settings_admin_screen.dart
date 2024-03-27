import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/admin/setting/coupon/coupon_screen.dart';
import './message_screen.dart';
import './shop_setting_screen.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../consts/lists.dart';
import '../controller/profile_admin_controller.dart';
import 'package:e_fashion/common/controllers/auth_controller.dart';
import '../../../services/firestore_service.dart';
import 'package:e_fashion/common/views/login_screen.dart';
import 'edit_profile_admin.dart';

class Setting_Admin_Screen extends StatelessWidget {
  const Setting_Admin_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileAdminController());
    // TODO: implement build
    return Scaffold(
      backgroundColor: darkFontGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditProfileAdminScreen(username: controller.snapshotData['vendor_name']));
              },
              icon: const Icon(
                Icons.edit,
                color: whiteColor,
              )),
          TextButton(onPressed: () async {
            VxToast.show(context, msg: loggedOut);
                                    await Get.put(AuthController())
                                        .signoutMethod(context);
                                    Get.offAll(() => const LoginScreen());
          }, child: normalText(text: "Logout"))
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getVendor(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor)));
          } else {
            controller.snapshotData = snapshot.data!.docs[0];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: controller.snapshotData['imageUrl'] != '' ? Image.network(controller.snapshotData['imageUrl']).box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    : Image.asset(imgB2)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make(),
                    title: boldText(text: "${controller.snapshotData['vendor_name']}"),
                    subtitle: normalText(text: "${controller.snapshotData['email']}"),
                  ),
                  const Divider(),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                          profileButtonTitles.length,
                          (index) => ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => ShopSetting(data: controller.snapshotData,));
                                      break;
                                    case 1:
                                      Get.to(() => const MessageScreen());
                                      break;
                                    case 2:
                                      Get.to(() => const CouponScreen());
                                    default:
                                  }
                                },
                                leading: Icon(
                                  profileButtonIcons[index],
                                  color: whiteColor,
                                ),
                                title: normalText(
                                    text: profileButtonTitles[index]),
                              )),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
