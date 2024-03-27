import 'package:e_fashion/admin/components/product_dropdown.dart';
import 'package:e_fashion/admin/controller/coupon_admin_controller.dart';

// import 'package:e_fashion/views/profile_screen/edit_profile.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';

class EditCoupon extends StatelessWidget {
  final dynamic data;
  const EditCoupon({super.key, this.data});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CouponAdminController>();
    controller.reset();
    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: darkFontGrey),
              onPressed: () {
                Get.back();
              },
            ),
            title: boldText(text: "Save", size: 16.0, color: fontGrey),
            actions: [
              controller.isLoading.value
                  ? loadingIndicator()
                  : TextButton(
                      onPressed: () async {
                        controller.isLoading(true);
                        await controller.addCoupon(context);
                        Get.back();
                      },
                      child: boldText(text: "Save", color: darkFontGrey)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextFieldAdmin(
                    hint: "eg. Coupon AA",
                    title: "Coupon name",
                    controller: controller.nameController,
                  ),
                  10.heightBox,
                  customTextFieldAdmin(
                    hint: "eg. Discount 10%",
                    title: "Description",
                    controller: controller.descriptionController,
                    isDesc: true,
                  ),
                  10.heightBox,
                  customTextFieldAdmin(
                    hint: "eg. 100",
                    title: "Value",
                    controller: controller.valueController,
                  ),
                  10.heightBox,
                  customTextFieldAdmin(
                    hint: "eg. 10",
                    title: "Amount",
                    controller: controller.amountController,
                  ),
                  10.heightBox,
                  couponDropdown("Type", controller.typeList,
                      controller.typeValue, controller),
                  ],
              ),
            ),
          ),
        ));
  }
}
