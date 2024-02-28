import 'dart:io';

import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/common/controllers/auth_controller.dart';
// import 'package:e_fashion/views/admin/auth/login_admin.dart';
import 'package:e_fashion/common/views/signup_screen.dart';
import 'package:e_fashion/user/views/home_screen/home.dart';
import 'package:e_fashion/user/views/home_screen/home_screen.dart';
import 'package:e_fashion/common/widgets/applogo_widget.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../consts/lists.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    // var controller = Get.put(dependency)

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     boldText(text: "You are logging as Customer", color: Colors.black, size: 16.0),
                //     (context.screenWidth-450).widthBox,
                //     ourButton(
                //       onPress: () {
                //         Get.to(() => const LoginAdminScreen());
                //       },
                //       color: darkFontGrey,
                //       title: "Login as Seller",
                //     ),
                //     10.widthBox,

                //   ],
                // ),
                
                10.heightBox,
                customTextField(
                    title: email,
                    hint: emailHint,
                    isPass: false,
                    controller: controller.emailController),
                customTextField(
                    title: password,
                    hint: passwordHint,
                    isPass: true,
                    controller: controller.passwordController),
                5.heightBox,
                controller.isLoading.value ? const CircularProgressIndicator( 
                  valueColor: AlwaysStoppedAnimation(redColor),
                ) : ourButton(
                    color: redColor,
                    title: login,
                    textColor: redColor,
                    onPress: 
                      () async {
                        controller.isLoading(true);

                        await controller
                            .loginMethod(context: context)
                            .then((value) async {
                          if (value != null) {
                            print("value is not null");
                            VxToast.show(context, msg: loggedIn);
                            Get.off(() => const Home());
                          }else{
                            print("value is null");
                            controller.isLoading(false);
                          }
                        });
                      }
                    ).box.width(context.screenWidth - 50).make(),
                5.heightBox,
                createNewAccount.text.color(fontGrey).make(),
                5.heightBox,
                ourButton(
                    color: golden,
                    title: singUp,
                    textColor: redColor,
                    onPress: () {
                      Get.to(() => const SignupScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                // loginWith.text.color(fontGrey).make(),
                // 5.heightBox,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //       3,
                //       (index) => Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: CircleAvatar(
                //               backgroundColor: lightGrey,
                //               radius: 25,
                //               child: Image.asset(
                //                 socialIconList[index],
                //                 width: 30,
                //               )))),
                // )
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make(),
          )
        ],
      )),
    ));
  }
}
