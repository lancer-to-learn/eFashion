import 'dart:io';

import 'package:e_fashion/user/controllers/profile_controller.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
            appBar: AppBar(),
            body: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //if data image url and controller path is empty
                    data['imageUrl'] == '' && controller.proflieImgPath.isEmpty
                        ? Image.asset(imgProfile, width: 50, fit: BoxFit.fill)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        // if data is not empty but controoler path is empty
                        : data['imageUrl'] != '' &&
                                controller.proflieImgPath.isEmpty
                            ? Image.network(
                                data['imageUrl'],
                                width: 50,
                                fit: BoxFit.fill,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            //else if controller path is not empty but data image url is
                            : kIsWeb
                                ? Image.memory(controller.webImage,
                                        fit: BoxFit.fill, width: 50)
                                    .box
                                    .roundedFull
                                    .clip(Clip.antiAlias)
                                    .make()
                                : Image.file(
                                    File(controller.proflieImgPath.value),
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                    10.heightBox,
                    ourButton(
                        color: redColor,
                        onPress: () {
                          controller.changeImage(context);
                        },
                        textColor: whiteColor,
                        title: "Change"),
                    const Divider(),
                    20.heightBox,
                    customTextField(
                        controller: controller.nameController,
                        hint: nameHint,
                        title: name,
                        isPass: false),
                    10.heightBox,
                    customTextField(
                        controller: controller.oldpasswordController,
                        hint: passwordHint,
                        title: oldpass,
                        isPass: true),
                    10.heightBox,
                    customTextField(
                        controller: controller.newpasswordController,
                        hint: passwordHint,
                        title: newpass,
                        isPass: true),
                    20.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : SizedBox(
                            width: context.screenWidth - 60,
                            child: ourButton(
                                color: redColor,
                                onPress: () async {
                                  controller.isloading(true);

                                  // if image is not selected
                                  if (controller
                                      .proflieImgPath.value.isNotEmpty) {
                                    try {
                                      await controller.uploadProfileImage();
                                    } catch (e) {
                                      print(e.toString());
                                      VxToast.show(context,
                                          msg: "Something went wrong!");
                                      controller.isloading(false);
                                      return;
                                    }
                                  } else {
                                    controller.proflieImageLink =
                                        data['imageUrl'];
                                  }

                                  // if user dont want to update password
                                  if (controller.oldpasswordController.text
                                          .trim() ==
                                      '') {
                                    if (controller.newpasswordController.text
                                            .trim() !=
                                        '') {
                                      VxToast.show(context,
                                          msg:
                                              "Current password is needed if you want to update it");
                                      controller.isloading(false);

                                      return;
                                    }
                                  } else //if user want to update password
                                  {
                                    if (controller.newpasswordController.text
                                            .trim() ==
                                        '') {
                                      VxToast.show(context,
                                          msg:
                                              "Current password is not required");
                                      controller.isloading(false);
                                      return;
                                    } else {
                                      try {
                                        if (controller
                                                .newpasswordController.text
                                                .trim()
                                                .length <
                                            6) {
                                          throw Exception(
                                              "Password should be at least 6 characters");
                                        }
                                        await controller.changeAuthPassword(
                                            email: data['email'],
                                            password: controller
                                                .oldpasswordController.text,
                                            newpassword: controller
                                                .newpasswordController.text);
                                      } catch (e) {
                                        print(e.toString());
                                        VxToast.show(context,
                                            msg: e.toString());
                                        controller.isloading(false);
                                        return;
                                      }
                                    }
                                  }

                                  if (controller.nameController.text.trim() ==
                                      "") {
                                    VxToast.show(context,
                                        msg: "Name field is empty");
                                  } else {
                                    try {
                                      await controller.updateProfile(
                                          imgUrl: controller.proflieImageLink,
                                          name: controller.nameController.text
                                              .trim(),
                                          password: controller
                                                      .newpasswordController
                                                      .text
                                                      .trim() ==
                                                  ""
                                              ? data['password']
                                              : controller
                                                  .newpasswordController.text
                                                  .trim());
                                    } catch (e) {
                                      print(e.toString());
                                      controller.isloading(false);
                                    }
                                  }

                                  controller.oldpasswordController.clear();
                                  controller.newpasswordController.clear();

                                  VxToast.show(context, msg: "Updated");
                                  controller.isloading(false);
                                },
                                textColor: whiteColor,
                                title: "Save"),
                          ),
                  ],
                )
                    .box
                    .white
                    .shadowSm
                    .padding(const EdgeInsets.all(16))
                    .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                    .rounded
                    .make())));
  }
}
