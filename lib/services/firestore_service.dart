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

  static getTop10Products() {
    // return firestore.collection(productsCollection).where();
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
}
