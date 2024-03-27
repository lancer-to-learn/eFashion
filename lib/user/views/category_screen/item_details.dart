import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/consts/lists.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/controllers/product_controller.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:e_fashion/user/views/category_screen/comment_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loading_indicator.dart';

// import 'package:e_fashion/views/chat_screen/chat_screen.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, this.title, this.data});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController commentController = TextEditingController();
    var controller = Get.put(ProductController());

    controller.addProductToSeen(data.id, currentUser!.uid);
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  controller.resetValue();
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back)),
            title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
            actions: [
              Obx(
                () => IconButton(
                    onPressed: () {
                      if (controller.isFav.value) {
                        controller.removeFromWishlist(data.id, context);
                      } else {
                        controller.addToWishlist(data.id, context);
                      }
                    },
                    icon: Icon(Icons.favorite_outlined,
                        color:
                            controller.isFav.value ? redColor : darkFontGrey)),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        aspectRatio: 16 / 9,
                        itemCount: data['p_imgs'].length,
                        viewportFraction: 1.0,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data["p_imgs"][index],
                            width: double.infinity,
                            fit: BoxFit.fitHeight,
                          );
                        }),

                    10.heightBox,
                    // title and detais section
                    title!.text
                        .size(16)
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,

                    Row(
                      children: [
                        //rating
                        VxRating(
                          isSelectable: false,
                          value: double.parse(data['p_rating'].toString()),
                          onRatingUpdate: (value) {},
                          normalColor: textfieldGrey,
                          selectionColor: golden,
                          count: 5,
                          size: 25,
                          maxRating: 5,
                        ),

                        Column(children: [
                          5.heightBox,
                          FutureBuilder(
                              future: controller.countBought(data.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              redColor)));
                                } else {
                                  return "(${snapshot.data} sold)"
                                      .toString()
                                      .text
                                      .size(15)
                                      .fontFamily(semibold)
                                      .color(textfieldGrey)
                                      .make();
                                }
                              }),
                        ])
                      ],
                    ),

                    10.heightBox,
                    "${data['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .fontFamily(bold)
                        .size(18)
                        .make(),

                    10.heightBox,
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "${data['p_seller']}"
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .size(16)
                                .make()
                          ],
                        )),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.message_rounded, color: darkFontGrey),
                        ).onTap(() {
                          Get.to(
                            // () => const ChatScreen(),
                            () => {},
                            arguments: [data['p_seller'], data['vendor_id']],
                          );
                        }),
                      ],
                    )
                        .box
                        .height(60)
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .color(textfieldGrey)
                        .make(),

                    //color section
                    20.heightBox,
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child:
                                    "Color: ".text.color(textfieldGrey).make(),
                              ),
                              Row(
                                children: List.generate(
                                    data['p_colors'].length,
                                    (index) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            VxBox()
                                                .size(40, 40)
                                                .roundedFull
                                                .color(Color(
                                                        data['p_colors'][index])
                                                    .withOpacity(1.0))
                                                .margin(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4))
                                                .make()
                                                .onTap(() {
                                              controller
                                                  .changeColorIndex(index);
                                            }),
                                            Visibility(
                                                visible: index ==
                                                    controller.colorIndex.value,
                                                child: const Icon(Icons.done,
                                                    color: Colors.white))
                                          ],
                                        )),
                              )
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          // quantity row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity: "
                                    .text
                                    .color(textfieldGrey)
                                    .make(),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.decreaseQuantity();
                                          controller.calculateTotalPrice(
                                              data['p_price']);
                                        },
                                        icon: const Icon(Icons.remove)),
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(darkFontGrey)
                                        .fontFamily(bold)
                                        .make(),
                                    IconButton(
                                        onPressed: () {
                                          controller.increaseQuantity(
                                              int.parse(data['p_quantity']));
                                          controller.calculateTotalPrice(
                                              data['p_price']);
                                        },
                                        icon: const Icon(Icons.add)),
                                    10.widthBox,
                                    "(${data['p_quantity']} available)"
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          // total row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child:
                                    "Total: ".text.color(textfieldGrey).make(),
                              ),
                              "${controller.totalPrice.value}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .size(16)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                        ],
                      ).box.white.shadowSm.make(),
                    ),

                    //description section
                    10.heightBox,
                    "Description"
                        .text
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,
                    "${data['p_desc']}".text.color(darkFontGrey).make(),

                    // button section
                    10.heightBox,

                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          itemDetailButtonsList.length,
                          (index) => ListTile(
                                title: itemDetailButtonsList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                trailing: const Icon(Icons.arrow_forward),
                              )),
                    ),
                    20.heightBox,

                    //comment section
                    FutureBuilder(
                        future: controller.countComment(data.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(redColor)));
                          } else {
                            return "Comments (${snapshot.data})"
                                .toString()
                                .text
                                .fontFamily(bold)
                                .size(17)
                                .color(Colors.black)
                                .make();
                          }
                        }),

                    // comment section
                    StreamBuilder(
                        stream: FirestoreServices.getUser(currentUser!.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(redColor)));
                          } else {
                            var userData = snapshot.data!.docs[0];

                            return SizedBox(
                              height: 400,
                              child: CommentBox(
                                  userImage: CommentBox.commentImageParser(
                                      imageURLorPath: userData['imageUrl']),
                                  labelText: 'Write a comment...',
                                  errorText: 'Comment cannot be blank',
                                  withBorder: false,
                                  sendButtonMethod: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.addComment(
                                          data.id,
                                          commentController.text
                                              .toString()
                                              .trim(),
                                          context);
                                      commentController.clear();
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      print("Not validated");
                                    }
                                  },
                                  formKey: formKey,
                                  commentController: commentController,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  sendWidget: const Icon(Icons.send_sharp,
                                      size: 30, color: Colors.white),
                                  child: FutureBuilder(
                                    future: controller.getAllComment(data.id),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        redColor)));
                                      } else if ((snapshot.data as List)
                                          .isEmpty) {
                                        return "No comments yet!"
                                            .text
                                            .color(darkFontGrey)
                                            .makeCentered();
                                      } else {
                                        var commentData = snapshot.data;

                                        return commentChild(commentData);
                                      }
                                    },
                                  )),
                            );
                          }
                        }),

                    20.heightBox,
                    //products you may like/similar products section
                    productYouMayAlsoLike.text
                        .fontFamily(bold)
                        .size(17)
                        .color(Colors.black)
                        .make(),

                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                            future: FirestoreServices.getSimilarProducts(
                                data['p_category']),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: loadingIndicator());
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No featured products"
                                    .text
                                    .white
                                    .makeCentered();
                              } else {
                                var featuredData = snapshot.data!.docs;

                                return Row(
                                  children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                  featuredData[index]['p_imgs']
                                                      [0],
                                                  width: 130,
                                                  height: 130,
                                                  // fit: BoxFit.fitHeight),
                                                  fit: BoxFit.cover),
                                              10.heightBox,
                                              "${featuredData[index]['p_name']}"
                                                  .text
                                                  .fontFamily(semibold)
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
                                              .margin(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4))
                                              .roundedSM
                                              .padding(const EdgeInsets.all(8))
                                              .make()
                                              .onTap(() {
                                            Get.to(() => ItemDetails(
                                                  title:
                                                      "${featuredData[index]['p_name']}",
                                                  data: featuredData[index],
                                                ));
                                          })),
                                );
                              }
                            })),
                  ],
                )),
              )),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ourButton(
                    color: redColor,
                    onPress: () {
                      if (controller.quantity.value > 0) {
                        controller.addToCart(
                          productId: data.reference.id,
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorId: data['vendor_id'],
                          img: data['p_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value,
                        );
                        VxToast.show(context, msg: "Added to cart");
                      } else {
                        VxToast.show(context,
                            msg: "Atleast 1 product required");
                      }
                    },
                    textColor: whiteColor,
                    title: "Add to cart"),
              )
            ],
          )),
    );
  }
}
