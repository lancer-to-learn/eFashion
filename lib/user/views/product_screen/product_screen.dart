import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/user/controllers/home_controller.dart';
import 'package:e_fashion/user/controllers/product_controller.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/views/category_screen/item_details.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../models/filter_model.dart';

class ProductScreen extends StatefulWidget {
  final String? title;
  const ProductScreen({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProducts();
    getFilters();
    isSearch = false;
    isFilter = false;
  }

  getAllProducts() {
    productMethod = FirestoreServices.allProducts();
  }
  search() {
    isSearch = true;
  }
  handleFilterClick() {
    isFilter = !isFilter;
  }
  
  getFilters() async {
    var data = await rootBundle.loadString("filter_model.json");
    var decoded = filterModelFromJson(data);
    print(decoded);
    filters = decoded.filters.toList();
  }
  searchProducts(data, kw) {
    if (data.isNotEmpty) {
      return data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(kw!.toLowerCase()),
                  )
                  .toList();
    }
  }
  filterProducts(filter) {
    productMethod = FirestoreServices.filterProduct(filter);
  }
  switchCategory(title) {
    isSearch = false;
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  var searchController = TextEditingController();
  var isFilter = false;
  var filters = [];
  dynamic productMethod;
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: "Products".text.fontFamily(bold).white.make(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (searchController.text.isNotEmpty) {
                                  search();
                                  setState(() {});
                                }
                              },
                              child: Icon(Icons.search),
                            ),
                            filled: true,
                            fillColor: whiteColor,
                            hintText: searchAnything,
                            hintStyle: TextStyle(color: textfieldGrey),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          handleFilterClick();
                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(icFilter, width: 30, height: 30, fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                ),
                5.heightBox,
                Visibility(
                  visible: isFilter,
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: 
                  Row(
                    children: List.generate(
                      filters.length,
                      (index) => "${filters[index].name}"
                                  .text
                                  .size(12)
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .makeCentered()
                                  .box
                                  .white
                                  .rounded
                                  .size(80, 40)
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .make()
                                  .onTap(() {
                                filterProducts(filters[index]);
                                setState(() {});
                              })),
                    )
                  // Row(
                  //   children: List.generate(
                  //     controller.subcat.length,
                  //     (index) => "${controller.subcat[index]}"
                  //                 .text
                  //                 .size(12)
                  //                 .fontFamily(semibold)
                  //                 .color(darkFontGrey)
                  //                 .makeCentered()
                  //                 .box
                  //                 .white
                  //                 .rounded
                  //                 .size(80, 40)
                  //                 .margin(
                  //                     const EdgeInsets.symmetric(horizontal: 4))
                  //                 .make()
                  //                 .onTap(() {
                  //               switchCategory("${controller.subcat[index]}");
                  //               setState(() {});
                  //             })),
                  //   )
                  ),),
                // Search box               
                20.heightBox,
                StreamBuilder(
                    stream: productMethod,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                          print(snapshot);
                      if (!snapshot.hasData) {
                        return Expanded(
                            child: Center(child: loadingIndicator()));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                            child: "No products found!"
                                .text
                                .color(darkFontGrey)
                                .makeCentered());
                      } else {
                        var data = isSearch ? searchProducts(snapshot.data!.docs, searchController.text) : snapshot.data!.docs;

                        return Expanded(
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 250,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(data[index]['p_imgs'][0],
                                              height: 150,
                                              width: 200,
                                              fit: BoxFit.cover)
                                          .box
                                          .roundedSM
                                          .clip(Clip.antiAlias)
                                          .make(),
                                      5.heightBox,
                                      "${data[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${data[index]['p_price']}"
                                          .numCurrency
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                      10.heightBox,
                                    ],
                                  )
                                      .box
                                      .white
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .roundedSM
                                      .outerShadowSm
                                      .padding(const EdgeInsets.all(12))
                                      .make()
                                      .onTap(() {
                                    controller.checkIfFav(data[index]);
                                    Get.to(() => ItemDetails(
                                        title: "${data[index]['p_name']}",
                                        data: data[index]));
                                  });
                                }));
                      }
                    }),
              ],
            )));
  }
}
