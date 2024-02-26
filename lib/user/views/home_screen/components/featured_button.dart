import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/user/views/category_screen/category_details.dart';
import 'package:get/get.dart';

Widget featuredButton({String? title, icon}) {
    return Row(children: [
      Image.asset(icon, width: 60, height: 50, fit: BoxFit.fill),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  ).box.width(200).margin(const EdgeInsets.symmetric(horizontal: 4)).white.padding(const EdgeInsets.all(4)).roundedSM.outerShadowSm.make().onTap(() {
    Get.to(() => CategoryDetails(title: title,));
  });
}

