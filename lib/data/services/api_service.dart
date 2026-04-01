import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/object_model.dart';
import '../../core/constants.dart';

// Service responsible for communicating with REST API.
// This class performs CRUD operations.
class ApiService {
  //  http client used to send requests
  final http.Client _client;
  // If client not provided → create default client.
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  // Helper method to build full API URL from endpoint path.
  Uri _uri(String path) => Uri.parse('${AppConstants.baseUrl}$path');
  // Common headers for POST/PUT requests. we send JSON to API.
  Map<String, String> get _headers => {'Content-Type': 'application/json'};
  // GET /objects → fetch list of objects from API
  Future<List<ObjectModel>> getObjects() async {
    final response = await _client.get(_uri(AppConstants.objectsEndpoint));
    _handleError(response);
    final List<dynamic> json = jsonDecode(response.body);
    // Convert List<JSON> → List<ObjectModel>
    return json.map((e) => ObjectModel.fromJson(e)).toList();
  }

  // GET /objects/{id},  Fetch single object.
  Future<ObjectModel> getObject(String id) async {
    final response = await _client.get(
      _uri('${AppConstants.objectsEndpoint}/$id'),
    );
    _handleError(response);
    return ObjectModel.fromJson(jsonDecode(response.body));
  }

  // POST /objects → create new object in API
  Future<ObjectModel> createObject(ObjectModel object) async {
    final response = await _client.post(
      _uri(AppConstants.objectsEndpoint),
      headers: _headers,
      body: jsonEncode(object.toJson()),
    );
    _handleError(response);
    return ObjectModel.fromJson(jsonDecode(response.body));
  }

  // PUT /objects/{id} → update existing object in API
  Future<ObjectModel> updateObject(ObjectModel object) async {
    final response = await _client.put(
      _uri('${AppConstants.objectsEndpoint}/${object.id}'),
      headers: _headers,
      body: jsonEncode(object.toJson()),
    );
    _handleError(response);
    return ObjectModel.fromJson(jsonDecode(response.body));
  }

  // DELETE /objects/{id} → delete object from API
  Future<void> deleteObject(String id) async {
    final response = await _client.delete(
      _uri('${AppConstants.objectsEndpoint}/$id'),
    );
    _handleError(response);
  }

  // Helper method to check API response for errors. If status code is not 2xx → throw exception with error details.
  void _handleError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API Error ${response.statusCode}: ${response.body}');
    }
  }
}
