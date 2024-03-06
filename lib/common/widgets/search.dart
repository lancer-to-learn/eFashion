import 'package:e_fashion/consts/consts.dart';
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

import '../controllers/search_controller.dart';

Widget search() {
  var controller = Get.put(SearchController());
  return Container(
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
            );
}