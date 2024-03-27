import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = [];
  var confirmed = false.obs;
  var onDelivery = false.obs;
  var delivered = false.obs;

  getOrders(data) {
    orders.clear();
    num total = 0;
    for (var item in data['orders']) {
      if (item['vendor_id']==currentUser!.uid) {
        orders.add(item);
        total = total + item['tprice'] * item['qty'];
      }
    }
    return total;
  }

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({
      title: status,
    } , SetOptions(merge: true));
    // isloading(false);
  }

  countOrders() async {
    await firestore
          .collection(ordersCollection)
          .where('vendors', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
  });
}
}
