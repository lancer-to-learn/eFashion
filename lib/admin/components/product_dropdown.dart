import 'package:e_fashion/admin/controller/coupon_admin_controller.dart';
import 'package:e_fashion/admin/controller/product_admin_controller.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

Widget productDropdown(
    hint, List<String> list, dropValue, ProductAdminController controller) {
      print('$hint: ${dropValue.value}');
  return Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: normalText(text: "$hint", color: fontGrey),
          value: dropValue.value == '' ? null : dropValue.value,
          isExpanded: true,
          items: list.map((e) {
            return DropdownMenuItem(
              value: e,
              child: e.toString().text.make(),
            );
          }).toList(),
          onChanged: (value) {
            if (hint == "Category") {
              controller.subcategoryValue.value = '';
              controller.getSubcategoryList(value.toString());
            }
            dropValue.value = value.toString();
          },
        ),
      )
          .box
          .white
          .padding(const EdgeInsets.symmetric(horizontal: 4))
          .roundedSM
          .make());
}

Widget couponDropdown(hint, List<String> list, dropValue, CouponAdminController controller) {
  return Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: normalText(text: "$hint", color: fontGrey),
          value: dropValue.value == '' ? null : dropValue.value,
          isExpanded: true,
          items: list.map((e) {
            return DropdownMenuItem(
              value: e,
              child: e.toString().text.make(),
            );
          }).toList(),
          onChanged: (value) {
            dropValue.value = value.toString();
          },
        ),
      )
          .box
          .white
          .padding(const EdgeInsets.symmetric(horizontal: 4))
          .roundedSM
          .make());
}
