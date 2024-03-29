import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/models/user_class.dart';
import 'package:path/path.dart';
import '../../common/controllers/db_controller.dart';
import 'home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var dbcontroller = DatabaseController();

  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;

    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  saveShipInformation() async {
    String email = '', password = '';
    await dbcontroller
        .users()
        .then((value) => {email = value.email, password = value.password});

    await dbcontroller.updateUser(UserClass(
        id: 0,
        email: email,
        password: password,
        address: addressController.text,
        state: stateController.text,
        city: cityController.text,
        postalcode: postalcodeController.text,
        phone: phoneController.text));
  }

  placeMyOder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);

    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': '2332413212',
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,

      'order_placed': true,
      'order_confirmed': false,
      'order_on_prepared': false,
      'order_on_delivery': false,
      'order_delivered': false,
      'order_cancelled': false,

      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors)
    });

    placingOrder(false);
  }

  getProductDetails() async {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      var currentProduct =
          await FirestoreServices.getProduct(productSnapshot[i]['productId']);
      if (currentProduct.data().containsKey('bought')) {
        await firestore
            .collection(productsCollection)
            .doc(productSnapshot[i]['productId'])
            .update({
          'bought': currentProduct['bought'] + productSnapshot[i]['qty']
        });
      } else {
        await firestore
            .collection(productsCollection)
            .doc(productSnapshot[i]['productId'])
            .set({'bought': productSnapshot[i]['qty']}, SetOptions(merge: true));
      }

      products.add({
        'P_id': productSnapshot[i]['productId'],
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
    print(products);
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  calculateOrderExpiredTime(time){
    var convertedTime = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
    DateTime orderTime = DateTime.parse(convertedTime.toString());
    return (orderTime.add(const Duration(minutes: 30))).toString();
  }
}
