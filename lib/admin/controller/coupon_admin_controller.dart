

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:get/get.dart';

class CouponAdminController extends GetxController {
  var isLoading = false.obs;
  var nameController = TextEditingController();
  var valueController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();

  var typeValue = ''.obs;
  var typeList = ['Constant', 'Percent'];

  reset() {
    isLoading = false.obs;
    nameController.text = '';
    valueController.text = '';
    amountController.text = '';
    descriptionController.text = '';
    typeValue.value = '';
  }

  addCoupon(context) async {
    var store = firestore.collection(couponCollection).doc();
    try {
      await store.set({
      'name': nameController.text,
      'users': FieldValue.arrayUnion([]),
      'description': descriptionController.text,
      'type': typeValue.value,
      'value': int.parse(valueController.text),
      'amount': int.parse(amountController.text),
      'vendor': currentUser!.uid,
      'activated': false,
    });
    isLoading(false);
    VxToast.show(context, msg: 'Uploaded Coupon!');
    } catch (e) {
      VxToast.show(context, msg: e.toString());
      print(e.toString());
    }
  }

  addFeature(docId) async {
    var store = firestore.collection(productsCollection).doc(docId);
    await store.set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    } , SetOptions(merge: true));
  }

  removeFeature(docId) async {
    var store = firestore.collection(productsCollection).doc(docId);
    await store.set({
      'featured_id': '',
      'is_featured': false,
    } , SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }

  // changeColorIndex(index) {
  //   colorIndex.value = index;
  // }

  // increaseQuantity(totalQuantity) {
  //   if (quantity.value < totalQuantity) {
  //     quantity.value++;
  //   }
  // }

  // decreaseQuantity() {
  //   if (quantity.value > 0) {
  //     quantity.value--;
  //   }
  // }

  // calculateTotalPrice(price) {
  //   totalPrice.value = price * quantity.value;
  // }

  // addToCart({title, img, sellername, color, qty, tprice, context, vendorId}) async {
  //   await firestore.collection(cartCollection).doc().set({
  //     'title': title,
  //     'img': img,
  //     'sellername': sellername,
  //     'color': color,
  //     'qty': qty,
  //     'vendor_id': vendorId,
  //     'tprice': tprice,
  //     'added_by': currentUser!.uid
  //   }).catchError((error) {
  //     VxToast.show(context, msg: error.toString());
  //   });
  // }

  // resetValue() {
  //   totalPrice.value = 0;
  //   quantity.value = 0;
  //   colorIndex.value = 0;
  // }

  // addToWishlist(docId, context) async {
  //   await firestore.collection(productsCollection).doc(docId).set({
  //     'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
  //   }, SetOptions(merge: true));
  //   isFav(true);
  //   VxToast.show(context, msg: "Added to wishlist");
  // }

  // removeFromWishlist(docId, context) async {
  //   await firestore.collection(productsCollection).doc(docId).set({
  //     'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
  //   }, SetOptions(merge: true));
  //   isFav(false);
  //   VxToast.show(context, msg: "Removed from wishlist");
  // }

  // checkIfFav(data) async {
  //   if (data['p_wishlist'].contains(currentUser!.uid)) {
  //     isFav(true);
  //   } else {
  //     isFav(false);
  //   }
  // }
}
