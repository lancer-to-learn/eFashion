import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import '../models/category_model.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;

  var subcat = [];
  var comments = [];
  var rates = [];
  var isFav = false.obs;

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart(
      {productId,
      title,
      img,
      sellername,
      color,
      qty,
      tprice,
      context,
      vendorId}) async {
    await firestore.collection(cartCollection).doc().set({
      'productId': productId,
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorId,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValue() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  addComment(docId, cmt, context) async {
    comments.clear();
    comments.add({"uid": currentUser!.uid, "cmt": cmt, "time": DateTime.now()});
    try {
      await firestore.collection(productsCollection).doc(docId).set(
          {'p_comments': FieldValue.arrayUnion(comments)},
          SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      VxToast.show(context, msg: "Something went wrong!");
    }
  }

  rateProduct(docId, value) async {
    rates.clear();
    var currentProduct = await FirestoreServices.getProduct(docId);

    double total = 0;
    if (currentProduct.data().containsKey('rates')) {
      rates.addAll(currentProduct['rates']);
      for (int i = 0; i < rates.length; i++) {
        if (rates[i]['uid'] == currentUser!.uid) {
          rates[i]['rate'] = value;
        }
        total += double.parse(rates[i]['rate']) ;
      }
      total = total/rates.length;
    } else {
      rates.add({"uid": currentUser!.uid, "rate": value});
      total = value;
    }
    // re-update rates
    await firestore
        .collection(productsCollection)
        .doc(docId)
        .set({'rates': null}, SetOptions(merge: true));
    await firestore
        .collection(productsCollection)
        .doc(docId)
        .set({'rates': FieldValue.arrayUnion(rates)}, SetOptions(merge: true));

    // calculate product rating
    await firestore
        .collection(productsCollection)
        .doc(docId)
        .set({'p_rating': total}, SetOptions(merge: true));
  }

  getAllComment(docId) async {
    try {
      var product = await FirestoreServices.getProduct(docId);
      //      name': 'Biggi Man',
      //     'pic': 'https://picsum.photos/300/30',
      //     'message': 'Very cool',
      //     'date': '2021-01-01 12:00:00'
      List cmtData = [];

      for (int i = 0; i < product['p_comments'].length; i++) {
        var user =
            await FirestoreServices.getOneUser(product['p_comments'][i]['uid']);

        var convertedTime = DateTime.fromMicrosecondsSinceEpoch(
            product['p_comments'][i]['time'].microsecondsSinceEpoch);
        DateTime orderTime = DateTime.parse(convertedTime.toString());

        cmtData.add({
          "name": user['name'],
          "pic": user['imageUrl'],
          "message": product['p_comments'][i]['cmt'],
          "date": orderTime.toString()
        });
      }

      return cmtData;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  countComment(docId) async {
    var product = await FirestoreServices.getProduct(docId);
    if (product.data().containsKey('p_comments')) {
      return product['p_comments'].length;
    }
    return 0;
  }

  countBought(docId) async {
    var product = await FirestoreServices.getProduct(docId);
    if (product.data().containsKey('bought')) {
      return product['bought'];
    }
    return 0;
  }

  addProductToSeen(docId, uId) async {
    await firestore.collection(usersCollections).doc(uId).set({
      'seen': FieldValue.arrayUnion([docId])
    }, SetOptions(merge: true));
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
