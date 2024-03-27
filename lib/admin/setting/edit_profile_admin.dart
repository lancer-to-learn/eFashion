import 'dart:io';

import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:get/get.dart';

import '../controller/profile_admin_controller.dart';

class EditProfileAdminScreen extends StatelessWidget {
  final String? username;
  const EditProfileAdminScreen({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileAdminController>();
    controller.nameController.text = username!;
    // var controller = Get.put(ProfileAdminController);

    return bgWidget(
        child: Scaffold(
            appBar: AppBar(),
            body: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //if data image url and controller path is empty
                    controller.snapshotData['imageUrl'] == '' && controller.proflieImgPath.isEmpty
                        ? Image.asset(imgB2, width: 50, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        // if data is not empty but controoler path is empty
                        : controller.snapshotData['imageUrl'] != '' &&
                                controller.proflieImgPath.isEmpty
                            ? Image.network(
                                controller.snapshotData['imageUrl'],
                                width: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            //else if controller path is not empty but data image url is
                            : Image.file(
                                File(controller.proflieImgPath.value),
                                width: 100,
                                fit: BoxFit.cover,
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
                    customTextFieldAdmin(
                        controller: controller.nameController,
                        hint: "eg. Chi",
                        title: name,
                        isPass: false),
                    10.heightBox,
                    customTextFieldAdmin(
                        controller: controller.oldpasswordController,
                        hint: passwordHint,
                        title: oldpass,
                        isPass: true),
                    10.heightBox,
                    customTextFieldAdmin(
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
                                  if(controller.proflieImgPath.value.isNotEmpty)
                                  {
                                    await controller.uploadProfileImage();
                                  }else{
                                      controller.proflieImageLink = controller.snapshotData['imageUrl'];
                                  }

                                  // if old password matches database
                                  if(controller.snapshotData['password'] == controller.oldpasswordController.text)
                                  {
                                    if (controller.newpasswordController.text.isNotEmpty) {
                                      await controller.changeAuthPassword(
                                      email: controller.snapshotData['email'],
                                      password: controller.oldpasswordController.text,
                                      newpassword: controller.newpasswordController.text
                                    );
                                    await controller.updateProfileNoPassword(
                                        imgUrl: controller.proflieImageLink,
                                        name: controller.nameController.text);
                                    VxToast.show(context, msg: "Updated");
                                    } else {
                                      await controller.updateProfile(
                                        imgUrl: controller.proflieImageLink,
                                        name: controller.nameController.text,
                                        password: controller
                                            .newpasswordController.text);
                                      VxToast.show(context, msg: "Updated");
                                    }                                     
                                  }else{
                                    VxToast.show(context, msg: "Incorrect password");
                                    controller.isloading(false);
                                  }
                                  
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
