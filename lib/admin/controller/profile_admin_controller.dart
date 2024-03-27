import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileAdminController extends GetxController {
  late QueryDocumentSnapshot snapshotData;

  var proflieImgPath = ''.obs;
  var proflieImageLink = '';
  var isloading = false.obs;

  //textfield
  var nameController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var descriptionController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      proflieImgPath.value = img.path;

    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async{
    var filename = basename(proflieImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(proflieImgPath.value));
    proflieImageLink = await ref.getDownloadURL(); 
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set({
      'vendor_name': name,
      'password': password,
      'imageUrl' : imgUrl
    } , SetOptions(merge: true));
    isloading(false);
  }

  updateProfileNoPassword({name, imgUrl}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set({
      'vendor_name': name,
      'imageUrl' : imgUrl
    } , SetOptions(merge: true));
    isloading(false);
  }

  updateShop({name, address, mobile, website, des}) async {
    var store = firestore.collection(vendorsCollections).doc(currentUser!.uid);
    await store.set({
      'shop_name': name,
      'shop_address': address,
      'shop_mobile' : mobile,
      'shop_website': website,
      'description': des,
    } , SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
        currentUser!.updatePassword(newpassword);
    }).catchError((error){
      print(error.toString());
    });

  }
}
