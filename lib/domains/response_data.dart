class ResponseData {
  bool _status;
  int _statusCode;
  String _message;
  List<dynamic> _data;

  ResponseData(this._status, this._statusCode, this._message, this._data);

  bool get status => _status;

  int get statusCode => _statusCode ?? 000;

  String get message => _message ?? '';

  List<dynamic> get data => _data ?? {};

  @override
  String toString() {
    return 'ResponseData{_status: $_status, _statusCode: $_statusCode, _message: $_message, _data: $_data}';
  }
}