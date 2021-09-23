class Ingredient {
  int _amount;
  String _name;
  int _unitId;

  @override
  String toString() {
    return 'Ingredient{_amount: $_amount, _name: $_name, _unitId: $_unitId}';
  }

  Ingredient(int amount, String name, int unitId){
    _amount = amount;
    _name = name;
    _unitId = unitId;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get unitId => _unitId;

  set unitId(int value) {
    _unitId = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': _amount,
      'name': name,
      'unitId': _unitId
    };
  }
}