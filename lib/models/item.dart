class Item {
  int? _id;
  late String _name;
  late String _kode;
  late int _price;
  late int _stok;

  int get id => _id!;

  String get name => this._name;

  set name(String value) {
    this._name = value;
  }
  String get kode => this._kode;

  set kode(String value) {
    this._kode = value;
  }

  int get price => this._price;

  set price(int value) {
    this._price = value;
  }
  int get stok => this._stok;

  set stok(int value) {
    this._stok = value;
  }
  Item(this._name, this._price, this._kode, this._stok);

  Item.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._price = map['price'];
    this._stok = map['stok'];
    this._kode = map['kode'];
  }
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['price'] = price;
    map['kode'] = kode;
    map['stok'] = stok;
    return map;
  }
}