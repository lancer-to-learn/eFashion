import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/consts/lists.dart';
import 'package:e_fashion/user/controllers/home_controller.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/views/category_screen/item_details.dart';
import 'package:e_fashion/user/views/home_screen/components/featured_button.dart';
import 'package:e_fashion/user/views/home_screen/search_screen.dart';
import 'package:e_fashion/common/widgets/home_buttons.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                          title: controller.searchController.text));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
              ),
            ),

            10.heightBox,

            // swipers brands
            Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      VxSwiper.builder(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          height: 150,
                          enlargeCenterPage: true,
                          itemCount: slidersList.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              slidersList[index],
                              fit: BoxFit.fill,
                            )
                                .box
                                .rounded
                                .clip(Clip.antiAlias)
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 8))
                                .make();
                          }),

                      10.heightBox,
                      //deals buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            2,
                            (index) => homeButton(
                                  height: context.screenHeight * 0.15,
                                  width: context.screenWidth / 2.5,
                                  icon: index == 0 ? icTodaysDeal : icFlashDeal,
                                  title: index == 0 ? todayDeal : flashSale,
                                )),
                      ),

                      // 2nd slider
                      10.heightBox,
                      VxSwiper.builder(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          height: 150,
                          enlargeCenterPage: true,
                          itemCount: secondSlidersList.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              secondSlidersList[index],
                              fit: BoxFit.fill,
                            )
                                .box
                                .rounded
                                .clip(Clip.antiAlias)
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 8))
                                .make();
                          }),

                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            3,
                            (index) => homeButton(
                                  height: context.screenHeight * 0.15,
                                  width: context.screenWidth / 3.5,
                                  icon: index == 0
                                      ? icTopCategories
                                      : index == 1
                                          ? icBrands
                                          : icTopSeller,
                                  title: index == 0
                                      ? topCategory
                                      : index == 1
                                          ? brand
                                          : topSellers,
                                )),
                      ),

                      //featured categories
                      20.heightBox,
                      Align(
                          alignment: Alignment.centerLeft,
                          child: featuredCategories.text
                              .color(darkFontGrey)
                              .size(18)
                              .fontFamily(semibold)
                              .make()),
                      20.heightBox,
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                3,
                                (index) => Column(
                                      children: [
                                        featuredButton(
                                            icon: featuredImages1[index],
                                            title: featuredTitles1[index]),
                                        10.heightBox,
                                        featuredButton(
                                            icon: index < 2 ? featuredImages2[index] : featuredImages1[0],
                                            title: index < 2 ? featuredTitles2[index] : featuredTitles1[0]),
                                      ],
                                    )).toList(),
                          ),
                      ),

                      // featured product
                      20.heightBox,
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: redColor,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              featuredProduct.text.white
                                  .fontFamily(bold)
                                  .size(18)
                                  .make(),
                              10.heightBox,
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: FutureBuilder(
                                      future: FirestoreServices
                                          .getFeaturedProducts(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child: loadingIndicator());
                                        } else if (snapshot
                                            .data!.docs.isEmpty) {
                                          return "No featured products"
                                              .text
                                              .white
                                              .makeCentered();
                                        } else {
                                          var featuredData =
                                              snapshot.data!.docs;

                                          return Row(
                                            children: List.generate(
                                                featuredData.length,
                                                (index) => Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.network(
                                                            featuredData[index]
                                                                ['p_imgs'][0],
                                                            width: 130,
                                                            height: 130,
                                                            fit: BoxFit.fitHeight),
                                                        10.heightBox,
                                                        "${featuredData[index]['p_name']}"
                                                            .text
                                                            .fontFamily(
                                                                semibold)
                                                            .color(darkFontGrey)
                                                            .make(),
                                                        10.heightBox,
                                                        "${featuredData[index]['p_price']}"
                                                            .numCurrency
                                                            .text
                                                            .color(redColor)
                                                            .fontFamily(bold)
                                                            .size(16)
                                                            .make(),
                                                      ],
                                                    )
                                                        .box
                                                        .white
                                                        .margin(const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 4))
                                                        .roundedSM
                                                        .padding(
                                                            const EdgeInsets
                                                                .all(8))
                                                        .make()
                                                        .onTap(() {
                                                      Get.to(() => ItemDetails(
                                                            title:
                                                                "${featuredData[index]['p_name']}",
                                                            data: featuredData[
                                                                index],
                                                          ));
                                                    })),
                                          );
                                        }
                                      })),
                            ]),
                      ),

                      // third swiper
                      20.heightBox,
                      VxSwiper.builder(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          height: 150,
                          enlargeCenterPage: true,
                          itemCount: secondSlidersList.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              secondSlidersList[index],
                              fit: BoxFit.fill,
                            )
                                .box
                                .rounded
                                .clip(Clip.antiAlias)
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 8))
                                .make();
                          }),

                      //all products sections
                      20.heightBox,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: "All Products"
                            .text
                            .fontFamily(bold)
                            .color(darkFontGrey)
                            .size(18)
                            .make(),
                      ),
                      20.heightBox,

                      StreamBuilder(
                          stream: FirestoreServices.allProducts(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return loadingIndicator();
                            } else {
                              var allproductsData = snapshot.data!.docs;
                              return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: allproductsData.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          mainAxisExtent: 300),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                            allproductsData[index]['p_imgs'][0],
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover),
                                        const Spacer(),
                                        "${allproductsData[index]['p_name']}"
                                            .text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "${allproductsData[index]['p_price']}"
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
                                        .padding(const EdgeInsets.all(12))
                                        .make()
                                        .onTap(() {
                                      Get.to(() => ItemDetails(
                                            title:
                                                "${allproductsData[index]['p_name']}",
                                            data: allproductsData[index],
                                          ));
                                    });
                                  });
                            }
                          }),
                    ],
                  )),
            ),
          ],
        )));
  }
}
