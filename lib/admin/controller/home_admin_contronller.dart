import 'package:e_fashion/consts/consts.dart';
import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  var navIndex = 0.obs;
  var username = '';

  @override
  void onInit() {
    super.onInit();
    getUsername();
  }

  getUsername() async {
    var n = await firestore.collection(vendorsCollections).where('id', isEqualTo: currentUser!.uid).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['vendor_name'];
      } else {
        return '';
      }
    });
    username = n;
  }
}