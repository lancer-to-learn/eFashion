import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/consts/lists.dart';
import '../controllers/auth_controller.dart';
import 'package:e_fashion/common/views/login_screen.dart';
import 'package:e_fashion/user/views/home_screen/home.dart';
import '../widgets/applogo_widget.dart';
import '../widgets/bg_widget.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/our_button.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Sign up for $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                customTextField(
                    title: name,
                    hint: nameHint,
                    controller: nameController,
                    isPass: false),
                customTextField(
                    title: email,
                    hint: emailHint,
                    controller: emailController,
                    isPass: false),
                customTextField(
                    title: password,
                    hint: passwordHint,
                    controller: passwordController,
                    isPass: true),
                customTextField(
                    title: retypePassword,
                    hint: retypePassword,
                    controller: passwordRetypeController,
                    isPass: true),
                5.heightBox,
                Row(
                  children: [
                    Checkbox(
                      activeColor: redColor,
                      checkColor: whiteColor,
                      value: isCheck,
                      onChanged: (newValue) => {
                        setState(() {
                          isCheck = newValue;
                        })
                      },
                    ),
                    10.widthBox,
                    Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                      TextSpan(
                          text: "I agree to the ",
                          style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                          )),
                      TextSpan(
                          text: tertmAndConditoin,
                          style: TextStyle(
                            fontFamily: regular,
                            color: redColor,
                          )),
                      TextSpan(
                          text: " & ",
                          style: TextStyle(
                            fontFamily: regular,
                            color: redColor,
                          )),
                      TextSpan(
                          text: privacyPolicy,
                          style: TextStyle(
                            fontFamily: regular,
                            color: redColor,
                          ))
                    ])))
                  ],
                ),
                5.heightBox,
                if (controller.isLoading.value)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                else
                  ourButton(
                      color: isCheck == true ? redColor : lightGrey,
                      title: singUp,
                      textColor: whiteColor,
                      onPress: () async {
                        if (isCheck != false) {
                          try {
                            if (passwordController.text !=
                                    passwordRetypeController.text ||
                                emailController.text == '' ||
                                nameController.text == '' ||
                                passwordController.text == '') {
                              throw Exception(
                                  'Please recheck your information');
                            }
                            controller.isLoading(true);
                            await controller
                                .signupMethod(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) async {
                              return await controller.storeUserData(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  uid: value!.user?.uid);
                            }).then((value) async {
                              VxToast.show(context, msg: pleaseVerifyEmail);

                              nameController.clear();
                              emailController.clear();
                              passwordController.clear();
                              passwordRetypeController.clear();
                              
                              // await controller.setTimerForAutoRedirect();
                            });
                          } catch (e) {
                            VxToast.show(context, msg: e.toString());
                            print(e.toString());
                          }
                          await auth.signOut();
                          controller.isLoading(false);
                        }
                      }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    alreadyHaveAccount.text.color(fontGrey).make(),
                    login.text.color(redColor).make().onTap(() {
                      Get.back();
                    }),
                  ],
                ),
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
