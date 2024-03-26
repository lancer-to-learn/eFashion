import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileController extends GetxController {
  var proflieImgPath = ''.obs;
  var proflieImageLink = '';
  var isloading = false.obs;
  File? _pickImage;
  Uint8List webImage = Uint8List(8);

  //textfield
  var nameController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();

  Future<void> changeImage(context) async {
    try {
      //if platform is mobile
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 70);
        if (image != null) {
          var selected = File(image.path);
          // setState(() {
          _pickImage = selected;
          proflieImgPath.value = image.path;

          // });
        } else {
          print("No image");
        }
      } else if (kIsWeb) //if platform is web
      {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 70);
        if (image != null) {
          var f = await image.readAsBytes();
          // setState(() {
          webImage = f;
          _pickImage = File('a');
          proflieImgPath.value = image.path;

          // });
        } else {
          print("No image");
        }
      } else {
        //platform either mobile or web
        throw (somethingWentWrong);
      }

      // final img = await ImagePicker()
      //     .pickImage(source: ImageSource.gallery, imageQuality: 70);
      // if (img == null) return;
      // proflieImgPath.value = img.path;
    } catch (e) {
      print(e.toString());
      VxToast.show(context, msg: "Choose image failed");
    }
  }

  uploadProfileImage() async {
    var destination = 'images/${currentUser!.uid}/profile_picture';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    if (!kIsWeb) {
      await ref.putFile(File(proflieImgPath.value));
    } else if (kIsWeb) {
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(webImage, metadata);
    } else
      throw (somethingWentWrong);

    proflieImageLink = await ref.getDownloadURL();
    print("Image url: " + proflieImageLink);
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(usersCollections).doc(currentUser!.uid);
    await store.set({'name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    });
  }

  getSeenProducts(seenList) async{
    List products = [];
    for(int i=0;i<seenList.length;i++)
    {
      products.add(await FirestoreServices.getProduct(seenList[i]));
    }
    return products;
  }
}
