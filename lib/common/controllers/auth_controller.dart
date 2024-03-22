import 'dart:async';
import 'dart:html';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/user/controllers/user_class.dart';
import 'package:e_fashion/common/views/login_screen.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/consts/firebase_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:e_fashion/common/controllers/db_controller.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  //text controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var dbcontroller = DatabaseController();

  //verify email
  Future<void> sendEmailVerification(context) async {
    try {
      await auth.currentUser?.sendEmailVerification();
      await signoutMethod(context);
    } catch (e) {
      VxToast.show(context, msg: somethingWentWrong);
      print(e.toString());
    }
  }

  //Timer to automatically redirect
  setTimerForAutoRedirect() async {
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
      //login with actual email & password
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      
      print("Current user: ");
      print(currentUser!.email);

      currentUser = userCredential.user;
      //add user to db
      if((await dbcontroller.users()).id == -1)
      {
        await dbcontroller.insertUser(UserClass(
            id: 0,
            email: emailController.text,
            password: passwordController.text,
          address: "", city: '', state: '', postalcode: '', phone: ''));
      }

      if (userCredential.user!.emailVerified == false) {
        VxToast.show(context, msg: 'Your email has not been verified');
      }
    } catch (e) {
      VxToast.show(context,
          msg: "No account found with provided email & password");
      print(e.toString());
    }
    return userCredential;
  }

  //Manually check if email verified
  Future<Widget> checkEmailVerificationStatus(context) async {
    if (auth.currentUser != null) {
      if (!auth.currentUser!.emailVerified) {
        return Column();
      }
    }
    return Row();
  }

  //Password retrieve
  Future<void> retrievePassword(context, email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

    } catch (e) {
      VxToast.show(context, msg: somethingWentWrong);
      print(e.toString());
    }
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: somethingWentWrong);
      print(e.toString());
    }

    print("##########");
    print("User created with:");
    print("Email: " + userCredential!.user!.email.toString());
    print("Uid: " + userCredential!.user!.uid.toString());
    print("##########");

    return userCredential;
  }

  //storing data method
  storeUserData({name, password, email, uid}) async {
    DocumentReference store = firestore.collection(usersCollections).doc(uid);

    await store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': uid,
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
      VxToast.show(context, msg: somethingWentWrong);
      print(e.toString());
    }
  }
}
