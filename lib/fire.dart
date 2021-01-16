import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NewsFirebase {
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

  Stream<bool> articleExist(String url) async* {
    try {
      var ref = firestore
          .collection("articles")
          .where("url", isEqualTo: url)
          .snapshots();
      await for (var data in ref) {
        if (data.docs.length > 0) {
          yield true;
        } else {
          yield false;
        }
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> logout() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      throw (e.toString());
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
      throw (e.toString());
      return false;
    }
  }

  Future<bool> removeArticle(Map<String, dynamic> article) async {
    try {
      var ref = await firestore
          .collection("articles")
          .where("url", isEqualTo: article["url"])
          .where("uid", isEqualTo: auth.currentUser.uid)
          .get();
      if (ref.size > 0) {
        var id = ref.docs[0].id;
        await firestore.collection("articles").doc(id).delete();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e.toString());
      return false;
    }
  }

  Query streamUserArticles() {
    return firestore
        .collection("articles")
        .where("uid", isEqualTo: auth.currentUser.uid);
  }
}

NewsFirebase newsFirebase = NewsFirebase();
