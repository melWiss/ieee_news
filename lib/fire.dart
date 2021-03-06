import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee_news/art_details.dart';

class FirebaseFunctions {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Stream<bool> existOrNot(String url) async* {
    try {
      var ref = firestore
          .collection("articles")
          .where("url", isEqualTo: url)
          .where("uid", isEqualTo: auth.currentUser.uid)
          .snapshots();
      await for (var data in ref) {
        if (data.docs.length > 0) {
          yield true;
        } else
          yield false;
      }
    } catch (e) {
      print(e.toString());
      yield null;
    }
  }

  Future<bool> saveArticle(Map<String, dynamic> article) async {
    try {
      var ref = firestore.collection("articles").doc();
      article["id"] = ref.id;
      article["uid"] = auth.currentUser.uid;
      await ref.set(article);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteArticle(Map<String, dynamic> article) async {
    try {
      var ref = await firestore
          .collection("articles")
          .where("uid", isEqualTo: auth.currentUser.uid)
          .where("url", isEqualTo: article["url"])
          .get();
      var refDoc = await ref.docs[0].reference.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<List<Map>> streamArticle() async* {
    try {
      var ref = await firestore
          .collection("articles")
          .where("uid", isEqualTo: auth.currentUser.uid)
          .snapshots();
      await for (var d in ref) {
        List<Map> listNews = [];
        d.docs.forEach((element) {
          listNews.add(element.data());
        });
        yield listNews;
      }
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }
}

FirebaseFunctions firebaseFunctions = FirebaseFunctions();
