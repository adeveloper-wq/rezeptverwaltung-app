import 'package:rezeptverwaltung/domains/ingredient.dart';
import 'package:rezeptverwaltung/domains/receipt_step.dart';

class Receipt {
  int _receiptId;
  String _name;
  int _portions;
  int _cookingTime;
  int _workingTime;
  int _restTime;
  int _groupId;

  int _createdAt;

  List<ReceiptStep> _steps;

  List<Ingredient> _ingredients;

  List<int> _tagIds;

  @override
  String toString() {
    return 'Receipt{_receiptId: $_receiptId, _name: $_name, _portions: $_portions, _cookingTime: $_cookingTime, _workingTime: $_workingTime, _restTime: $_restTime, _groupId: $_groupId, _createdAt: $_createdAt, _steps: $_steps, _ingredients: $_ingredients, _tagIds: $_tagIds}';
  }

  Receipt(){
    _ingredients = [];
    _tagIds = [];
    _steps = [];
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get portions => _portions;

  set portions(int value) {
    _portions = value;
  }

  int get cookingTime => _cookingTime;

  set cookingTime(int value) {
    _cookingTime = value;
  }

  int get workingTime => _workingTime;

  set workingTime(int value) {
    _workingTime = value;
  }

  int get restTime => _restTime;

  set restTime(int value) {
    _restTime = value;
  }

  List<ReceiptStep> get steps => _steps;

  set steps(List<ReceiptStep> value) {
    _steps = value;
  }

  List<Ingredient> get ingredients => _ingredients;

  set ingredients(List<Ingredient> value) {
    _ingredients = value;
  }

  List<int> get tagIds => _tagIds;

  set tagIds(List<int> value) {
    _tagIds = value;
  }

  List<String> getTagIdStrings(){
    List<String> tagIdsString = [];
    for(int tag in _tagIds){
      tagIdsString.add(tag.toString());
    }
    return tagIdsString;
  }

  int get groupId => _groupId;

  set groupId(int value) {
    _groupId = value;
  }
}