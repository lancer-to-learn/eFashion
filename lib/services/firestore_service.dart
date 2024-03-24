import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:flutter/services.dart';

class FirestoreServices {
  static getUser(uid) {
    return firestore
        .collection(usersCollections)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static getVendor(uid) {
    return firestore
        .collection(vendorsCollections)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get products by category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  static getSimilarProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .get();
  }

  static filterProduct(filter) {
    return firestore
        .collection(productsCollection)
        .where('p_price', isGreaterThan: filter.min)
        .where('p_price', isLessThan: filter.max)
        .snapshots();
  }

  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  //get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //delete doc
  static deleteDocument(docId) async {
    return await firestore.collection(cartCollection).doc(docId).delete();
  }

  // get all chat messages
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getOrdersByVendor() {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getDashboard() async {
    var n = await getProductsByVendor(currentUser!.uid);
    var o = await getOrdersByVendor();
    return [n, 0];
  }

  static getWishLists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAllAdminMessages() {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static getProduct(id) {
    return firestore
        .collection(productsCollection).doc(id).get();
  }

  static allProducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  static getTopProducts(limit) {
    return firestore
        .collection(productsCollection)
        .orderBy("bought").limit(limit)
        .snapshots();
  }

  static getProductsByVendor(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  // get featured product
  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  //get search product
  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  static search(kw) {
    return firestore
        .collection(productsCollection)
        .where('p_name', arrayContains: kw)
        .snapshots();
  }

  static getPopularProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .orderBy('p_wishlist'.length)
        .get();
  }

  static cancellOrder(data) async {
    if(data["order_on_prepared"] || data["order_on_prepared"])
    {
      // data.reference.id
      firestore.collection(ordersCollection).doc(data.id).update({
        "order_cancelled": true
      });
      return "Your request has been sent to vendor!";
    }
    else if (data["order_placed"])
    {
      var convertedTime = DateTime.fromMicrosecondsSinceEpoch(data["order_date"].microsecondsSinceEpoch);
      DateTime orderTime = DateTime.parse(convertedTime.toString());
      DateTime currentTime = DateTime.now();

      DateTime expriredTime = orderTime.add(const Duration(minutes: 30));
      if(currentTime.compareTo(expriredTime) >= 0) {
        return "Time to cancell this order is expired";
      } else {
        await firestore.collection(ordersCollection).doc(data.id).delete();
        return "Order cancelled";
      }
    }
    return "request failed";
  }
}
