import 'package:e_fashion/consts/consts.dart';
import 'package:get/get.dart';

class SearchControllers extends GetxController {

  @override
  void onInit() {
    getUserName();
    super.onInit();
  }

  var currentNavIndex = 0.obs;
  var username = '';
  var searchController = TextEditingController();

  getUserName() async {
    var n  = await firestore.collection(usersCollections).where('id', isEqualTo: currentUser!.uid).get()
      .then((value)  {
          if(value.docs.isNotEmpty)
          {
            return value.docs.single['name'];
          } else {
            return '';
          }
      });

      username = n;
      
  }
}