class Product {
  int? id;
  int? categoryId;
  String? name;
  String? description;
  String? imgUrl;
  String? quantityPerUnit;
  double? unitPrice;
  int? unitsInStock;

  Product({
    this.id,
    this.categoryId,
    this.name,
    this.description,
    this.imgUrl,
    this.quantityPerUnit,
    this.unitPrice,
    this.unitsInStock,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map["id"],
        categoryId: map["categoryId"],
        name: map["name"],
        description: map["description"],
        imgUrl: map["imgUrl"],
        quantityPerUnit: map["quantityPerUnit"],
        unitPrice: map["unitPrice"],
        unitsInStock: map["unitsInStock"],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "categoryId": categoryId,
      "name": name,
      "description": description,
      "imgUrl": imgUrl,
      "quantityPerUnit": quantityPerUnit,
      "unitPrice": unitPrice,
      "unitsInStock": unitsInStock,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
