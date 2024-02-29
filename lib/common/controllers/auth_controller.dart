import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/common/views/login_screen.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  //text controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //verify email
  Future<void> sendEmailVerification(context) async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } catch (e) {
      VxToast.show(context, msg: 'Something went wrong');
      print(e.toString());
    }
  }

  //Timer to automatically redirect
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await auth.currentUser?.reload();
      final user = auth.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => const LoginScreen());
      }
    });
  }

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (userCredential.user!.emailVerified  == false) {
        VxToast.show(context, msg: 'Please vefiry your email');
        await signoutMethod(context);

        print(userCredential.user?.displayName);
      }
      print('Email is verified');
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //Manually check if email verified
  checkEmailVerificationStatus() async {
    final currentUser = auth.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      print("User is available & email verified");
      Get.off(const LoginScreen());
    }
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);

      VxToast.show(context, msg: 'Please check your Email for verification');
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollections).doc(currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'wishlist_count': "00",
      'order_count': "00",
    });
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
