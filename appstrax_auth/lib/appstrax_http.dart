part of appstrax_auth;

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() {
    return _instance;
  }
  HttpService._internal();

  StorageService _storageService = StorageService();

  Future<dynamic> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: getHeaders());

    return _handleResponse(response);
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> patch(String url, Map<String, dynamic> body) async {
    http.Response response = await http.patch(
      Uri.parse(url),
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    http.Response response = await http.put(
      Uri.parse(url),
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(String url) async {
    http.Response response = await http.delete(
      Uri.parse(url),
      headers: getHeaders(),
    );

    return _handleResponse(response);
  }

  _handleResponse(http.Response response) {
    if (response.statusCode > 299 || response.statusCode < 200) {
      throw response.body;
    }

    try {
      return jsonDecode(response.body);
    } catch (err) {
      return response.body;
    }
  }

  Map<String, String> getHeaders() {
    var token = _storageService.getAuthToken();
    if (token != null && token != '') {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token
      };

      return headers;
    }

    return {'Content-Type': 'application/json'};
  }
}
