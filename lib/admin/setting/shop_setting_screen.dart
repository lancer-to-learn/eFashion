
import './settings_admin_screen.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../controller/profile_admin_controller.dart';

class ShopSetting extends StatelessWidget {
  final dynamic data;
  const ShopSetting({super.key, this.data});


  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileAdminController>();
        controller.shopNameController.text = data['shop_name'];
        controller.shopAddressController.text = data['shop_address'];
        controller.shopMobileController.text = data['shop_mobile'];
        controller.shopWebsiteController.text = data['shop_website'];
        controller.descriptionController.text = data['description'];
    // TODO: implement build
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
       title: boldText(text: "Shop Settings", size: 16.0, color: darkFontGrey),
       actions: [
        controller.isloading.value ? loadingIndicator() :
        TextButton(onPressed: () async {
          controller.isloading(true);
        await controller.updateShop(
          name: controller.shopNameController.text,
          address: controller.shopAddressController.text,
          mobile: controller.shopMobileController.text,
          website: controller.shopWebsiteController.text,
          des: controller.descriptionController.text,
        );
        VxToast.show(context, msg: "Updated");
        Get.to(() => const Setting_Admin_Screen());
       }, child: normalText(text: "Save", color: darkFontGrey))], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            customTextFieldAdmin(
              controller: controller.shopNameController,
              title: "Shop's Name",
              hint: controller.snapshotData['shop_name'],
              enabled: false,
            ),
            10.heightBox,
            customTextFieldAdmin(
              controller: controller.shopAddressController,
              title: "Address",
              hint: controller.snapshotData['shop_address'],
            ),
            10.heightBox,
            customTextFieldAdmin(
              controller: controller.shopMobileController,
              title: "Phone number",
              hint: controller.snapshotData['shop_mobile'],
            ),
            10.heightBox,
            customTextFieldAdmin(
              controller: controller.shopWebsiteController,
              title: "Website",
              hint: controller.snapshotData['shop_website'],
            ),
            10.heightBox,
            customTextFieldAdmin(
              controller: controller.descriptionController,
              title: "Description",
              hint: controller.snapshotData['description'],
              isDesc: true,
            ),
          ],
        ),
      ),
    );
  }
}