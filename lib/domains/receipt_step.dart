class ReceiptStep {
  int _stepNumber;
  String _instruction;

  @override
  String toString() {
    return 'ReceiptStep{_stepNumber: $_stepNumber, _instruction: $_instruction}';
  }

  ReceiptStep(this._stepNumber, this._instruction);

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': _stepNumber,
      'instruction': _instruction,
    };
  }

  String get instruction => _instruction;

  set instruction(String value) {
    _instruction = value;
  }

  int get stepNumber => _stepNumber;

  set stepNumber(int value) {
    _stepNumber = value;
  }
}