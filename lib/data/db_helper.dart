import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class DbHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateProductsForSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore.collection('product').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String name = doc['name'].toString().toLowerCase();
      List<String> words = name.split(' ');

      await doc.reference.update({
        'lowercaseName': name,
        'nameWords': words,
      });
    }
  }


  Future<int> getNextUserId() async {
    QuerySnapshot snapshot = await _firestore.collection('users').orderBy('id', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) {
      return 1;
    } else {
      int highestId = snapshot.docs.first['id'];
      return highestId + 1;
    }
  }

  Future<void> registerUser(String username, String email, String password, String imgUrl, bool isAdmin) async {
    int userId = await getNextUserId();
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'id': userId,
      'username': username,
      'email': email,
      'imgUrl': imgUrl,
      'isAdmin': isAdmin,
    });
  }

  Future<void> signInUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    return snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};
  }

  Future<void> updateUserInfo(String userId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(userId).update(updatedData);
  }

  Future<void> addOrderToUser(String userId, Map<String, dynamic> order) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    print(userId);
    DocumentSnapshot snapshot = await userRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      List orders = userData['orders'] ?? [];
      orders.add(order);
      await userRef.update({'orders': orders});
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('category').get();
    return snapshot.docs.map((doc) => {
      'id': int.tryParse(doc.id),
      'categoryName': doc['categoryName'],
    }).toList();
  }


  Future<List<Map<String, dynamic>>> getProducts() async {
    updateProductsForSearch();
    QuerySnapshot snapshot = await _firestore.collection('product').get();
    return snapshot.docs.map((doc) => {
      'id': int.tryParse(doc.id),
      'categoryId': doc['categoryId'] is int ? doc['categoryId'] : int.tryParse(doc['categoryId'].toString()),
      'name': doc['name'],
      'description': doc['description'],
      'imgUrl': doc['imgUrl'],
      'quantityPerUnit': doc['quantityPerUnit'],
      'unitPrice': doc['unitPrice'] is double ? doc['unitPrice'] : double.tryParse(doc['unitPrice'].toString()),
      'unitsInStock': doc['unitsInStock'] is int ? doc['unitsInStock'] : int.tryParse(doc['unitsInStock'].toString()),
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId) async {
    QuerySnapshot snapshot = await _firestore.collection('product')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map((doc) => {
      'id': int.tryParse(doc.id),
      'categoryId': doc['categoryId'] is int ? doc['categoryId'] : int.tryParse(doc['categoryId'].toString()),
      'name': doc['name'],
      'description': doc['description'],
      'imgUrl': doc['imgUrl'],
      'quantityPerUnit': doc['quantityPerUnit'],
      'unitPrice': doc['unitPrice'] is double ? doc['unitPrice'] : double.tryParse(doc['unitPrice'].toString()),
      'unitsInStock': doc['unitsInStock'] is int ? doc['unitsInStock'] : int.tryParse(doc['unitsInStock'].toString()),
    }).toList();
  }

  Future<List<Map<String, dynamic>>> searchProductsByName(String productName) async {
    String searchQuery = productName.toLowerCase();
    List<String> searchWords = searchQuery.split(' ');

    QuerySnapshot snapshot = await _firestore.collection('product')
        .where('nameWords', arrayContainsAny: searchWords)
        .get();

    return snapshot.docs.map((doc) => {
      'id': int.tryParse(doc.id),
      'categoryId': doc['categoryId'] is int ? doc['categoryId'] : int.tryParse(doc['categoryId'].toString()),
      'name': doc['name'],
      'description': doc['description'],
      'imgUrl': doc['imgUrl'],
      'quantityPerUnit': doc['quantityPerUnit'],
      'unitPrice': doc['unitPrice'] is double ? doc['unitPrice'] : double.tryParse(doc['unitPrice'].toString()),
      'unitsInStock': doc['unitsInStock'] is int ? doc['unitsInStock'] : int.tryParse(doc['unitsInStock'].toString()),
    }).toList();
  }



  Future<Map<String, dynamic>> getCart(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('carts').doc(userId).get();
    return snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};
  }

  Future<void> emptyCart(String userId) async {
    DocumentReference cartRef = _firestore.collection('carts').doc(userId);
    DocumentSnapshot snapshot = await cartRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> fields = snapshot.data() as Map<String, dynamic>;

      Map<String, dynamic> updates = {};
      fields.forEach((key, value) {
        updates[key] = FieldValue.delete();
      });

      await cartRef.update(updates);
    }
  }

  Future<void> addOrUpdateCartItem(String userId, CartItem cartItem) async {
    DocumentReference cartRef = _firestore.collection('carts').doc(userId);
    DocumentSnapshot snapshot = await cartRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> cartData = snapshot.data() as Map<String, dynamic>;
      if (cartData.containsKey(cartItem.product.id.toString())) {
        cartData[cartItem.product.id.toString()]['quantity'] += cartItem.quantity;
      } else {
        cartData[cartItem.product.id.toString()] = cartItem.toMap();
      }
      await cartRef.update(cartData);
    } else {
      await cartRef.set({
        cartItem.product.id.toString(): cartItem.toMap(),
      });
    }
  }

  Future<void> removeFromCart(String userId, CartItem cartItem) async {
    DocumentReference cartRef = _firestore.collection('carts').doc(userId);
    DocumentSnapshot snapshot = await cartRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> cartData = snapshot.data() as Map<String, dynamic>;
      if (cartData.containsKey(cartItem.product.id.toString())) {
        if (cartData[cartItem.product.id.toString()]['quantity'] > 1) {
          cartData[cartItem.product.id.toString()]['quantity'] -= 1;
          await cartRef.update(cartData);
        } else if (cartData[cartItem.product.id.toString()]['quantity'] == 1) {
          cartData.remove(cartItem.product.id.toString());
          await cartRef.set(cartData);
        }
      }
    }
  }
}
