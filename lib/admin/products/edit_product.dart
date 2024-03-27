import '../controller/product_admin_controller.dart';
// import 'package:e_fashion/views/profile_screen/edit_profile.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';


import '../../../consts/consts.dart';
import '../../../consts/lists.dart';
import '../components/product_dropdown.dart';
import '../components/product_images.dart';


class EditProduct extends StatelessWidget {
  final dynamic data;
  const EditProduct({super.key, this.data});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductAdminController>();
    controller.reset();
    controller.categoryList.clear();
    controller.subcategoryList.clear();
    controller.getCategoryList();
    
    controller.categoryValue.value = data['p_category'];
    controller.subcategoryValue.value = data['p_subcategory'];
    controller.getSubcategoryList(controller.categoryValue.value);
    controller.nameController.text = data['p_name'];
    controller.quantityController.text = data['p_quantity'];
    controller.priceController.text = data['p_price'];
    controller.descController.text = data['p_desc'];
    controller.imageLinks = data['p_imgs'];
    controller.listColor = data['p_colors'];
    controller.getSelectedColors();

    print(controller.imageLinks);
    print(controller.subcategoryValue.value);
    return Obx(()=>
    Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: darkFontGrey),
            onPressed: () {
              Get.back();
            },
          ),
          title: boldText(text: "Edit Product", size: 16.0, color: fontGrey),
          actions: [
            controller.isLoading.value ? loadingIndicator() :
            TextButton(onPressed: () async {
              controller.isLoading(true);
              // await controller.uploadImages();
              await controller.uploadProduct(context);
              Get.back();
            }, child: boldText(text: "Save", color: darkFontGrey)),
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
                hint: "eg. Nike",
                title: "Product name",
                controller: controller.nameController,
              ),
              10.heightBox,
              customTextFieldAdmin(                
                hint: "eg. Good product",
                title: "Description",
                controller: controller.descController,
                isDesc: true,               
              ),
              10.heightBox,
              customTextFieldAdmin(
                hint: "eg. 100",
                title: "Price",
                controller: controller.priceController,
              ),
              10.heightBox,
              customTextFieldAdmin(
                hint: "eg. 10",
                title: "Quantity",
                controller: controller.quantityController,
              ),
              10.heightBox,
              productDropdown("Category", controller.categoryList, controller.categoryValue, controller),
              10.heightBox,
              productDropdown("Subcategory", controller.subcategoryList, controller.subcategoryValue, controller),
              10.heightBox,
              const Divider(color: whiteColor),
              boldText(text: "Choose product images", color: darkFontGrey),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  // 3, (index) => controller.imageList[index] != null 
                  // ? Image.file(controller.imageList[index], width: 100,).onTap(() {
                  //   controller.pickImage(index, context);
                  // })
                  // : ProductImage(label: "${index + 1}").onTap(() {
                  //   controller.pickImage(index, context);
                  // }),
                  3, (index) => controller.imageLinks[index] != null 
                  ? Image.network(controller.imageLinks[index], width: 100, height: 100,).onTap(() {
                    controller.pickImage(index, context);
                  })
                  : ProductImage(label: "${index + 1}").onTap(() {
                    controller.pickImage(index, context);
                  }),
                )
              ),
              10.heightBox,
              const Divider(color: whiteColor),
              10.heightBox,
              boldText(text: "Choose product colors", color: darkFontGrey),
              10.heightBox,
              Obx(() => Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  colorList.length, (index) => Stack(
                    alignment: Alignment.center,
                    children: [
                      VxBox()
                              .color(Color(colorList[index]))
                              .roundedFull
                              .size(65, 65)
                              .make()
                              .onTap(() {
                            
                            if (controller.listColor.contains(colorList[index])) {
                              controller.listColor.remove(colorList[index]);
                              controller.selectedColorIndex.remove(index);
                            } else {
                              controller.listColor.add(colorList[index]);
                              controller.selectedColorIndex.add(index);
                            }
                            print(controller.listColor);
                          }),
                      controller.selectedColorIndex.contains(index) 
                      ? const Icon(Icons.done, color: whiteColor) 
                      : const SizedBox(),
                      
                    ]
                  ),
                )
              )),


            ],
          ),
          ),
        ),
    ));
  }
}
