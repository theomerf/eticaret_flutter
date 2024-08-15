class Account {
  int? id;
  String? username;
  String? email;
  String? password;
  String? imgUrl;
  List<dynamic>? orders;
  bool? isAdmin;

  Account({
    this.id,
    this.username,
    this.email,
    this.password,
    this.imgUrl,
    this.orders,
    this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'imgUrl': imgUrl,
      'orders': orders,
      'isAdmin': isAdmin,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      imgUrl: map['imgUrl'],
      orders: map['orders'],
      isAdmin: map['isAdmin'],
    );
  }
}