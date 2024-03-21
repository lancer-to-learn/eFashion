import 'package:e_fashion/consts/consts.dart';
import '../../../common/controllers/db_controller.dart';
import '../../controllers/cart_controller.dart';
import 'payment_screen.dart';
import 'package:e_fashion/common/widgets/custom_textfield.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var dbcontroller = DatabaseController();
    dbcontroller.users().then((value) => {
          controller.addressController.text = value.address,
          controller.cityController.text = value.city,
          controller.stateController.text = value.state,
          controller.postalcodeController.text = value.postalcode,
          controller.phoneController.text = value.phone
        });

    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Shipping Info"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ourButton(
            onPress: () {
              if(controller.addressController.text.length > 10 && 
                  controller.cityController.text.isNotEmpty &&
                  controller.stateController.text.isNotEmpty &&
                  controller.postalcodeController.text.isNotEmpty && num.tryParse(controller.postalcodeController.text) != null &&
                  controller.phoneController.text.length <= 11 && num.tryParse(controller.phoneController.text) != null){
                Get.to(() => const PaymentMethods());
              } else {
                VxToast.show(context, msg: "Please re-check your information");
              }
            },
            color: redColor,
            textColor: redColor,
            title: "Continue",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              customTextField(
                  hint: "Must be greater than 10 characters",
                  isPass: false,
                  title: "Adress",
                  controller: controller.addressController),
              customTextField(
                  hint: "Enter destined City",
                  isPass: false,
                  title: "City",
                  controller: controller.cityController),
              customTextField(
                  hint: "Enter destined State",
                  isPass: false,
                  title: "State",
                  controller: controller.stateController),
              customTextField(
                  hint: "Contain only numbers",
                  isPass: false,
                  title: "Postal Code",
                  controller: controller.postalcodeController),
              customTextField(
                  hint: "No greater than 11 characters",
                  isPass: false,
                  title: "Phone",
                  controller: controller.phoneController),
            ],
          ),
        ));
  }
}
