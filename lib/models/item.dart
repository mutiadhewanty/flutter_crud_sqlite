class Item {
  int? _id;
  late String _name;
  late int _price;

  int get id => _id!;

  String get name => this._name;

  set name(String value) {
    this._name = value;
  }

  int get price => this._price;

  set price(int value) {
    this._price = value;
  }
  Item(this._name, this._price);

  Item.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._price = map['price'];
  }
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['price'] = price;
    return map;
  }
}