import 'dart:js';

import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/user/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'our_button.dart';
import 'package:flutter/services.dart';

Widget rateDialog(context, docId) {
  var controller = Get.put(ProductController());

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "How do you like this product?"
            .text
            .fontFamily(bold)
            .size(18)
            .color(darkFontGrey)
            .make(),
        10.heightBox,

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VxRating(
              value: 0,
              isSelectable: true,
              onRatingUpdate: (value) async {
                try {
                  await controller.rateProduct(docId, value);
                  VxToast.show(context, msg: "Thanks for your feedback!");
                } catch (e) {
                  print(e.toString());
                  VxToast.show(context, msg: "Something went wrong!");
                }
              },          
              normalColor: textfieldGrey,
              selectionColor: golden,
              count: 5,
              size: 30,
              maxRating: 5,
            ),
          ],
        ),

        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ourButton(
                color: redColor,
                onPress: () {
                  Navigator.pop(context, true);
                },
                textColor: whiteColor,
                title: "Confirm"),
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
