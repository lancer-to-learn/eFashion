import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/user/views/product_screen/product_screen.dart';
import 'package:get/get.dart';
import 'package:e_fashion/consts/lists.dart';
import 'package:e_fashion/user/controllers/product_controller.dart';
import 'package:e_fashion/user/views/category_screen/category_details.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 200), itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(categoriesImages[index], height: 120, width: 200, fit: BoxFit.cover),
                10.heightBox,
                categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make(),
              ],
            ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {

              controller.getSubCategories(categoriesList[index]);
              Get.to(() => ProductScreen(title: categoriesList[index]));
            });
          }))
      )
    );
  }
}
