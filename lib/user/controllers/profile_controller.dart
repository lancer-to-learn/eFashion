import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var proflieImgPath = ''.obs;
  var proflieImageLink = '';
  var isloading = false.obs;

  //textfield
  var nameController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();

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
    var store = firestore.collection(usersCollections).doc(currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'imageUrl' : imgUrl
    } , SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
        currentUser!.updatePassword(newpassword);
    });
  }
}
