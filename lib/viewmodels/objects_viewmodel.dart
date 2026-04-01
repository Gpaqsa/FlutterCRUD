import 'package:flutter/foundation.dart';
import '../data/models/object_model.dart';
import '../data/services/api_service.dart';

// Enum representing the current state of the view (idle, loading, error).
enum ViewState { idle, loading, error }

//
class ObjectsViewModel extends ChangeNotifier {
  final ApiService _apiService;
  // If apiService not provided → create default ApiService instance.
  ObjectsViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  // Private list of objects fetched from API
  List<ObjectModel> _objects = [];
  // Current screen state
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  List<ObjectModel> get objects => _objects;
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  // Helper method to update state and notify listeners.
  void _setState(ViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }

  // Fetch list of objects from API and update state accordingly.
  Future<void> fetchObjects() async {
    _setState(ViewState.loading);
    try {
      _objects = await _apiService.getObjects();
      _setState(ViewState.idle);
    } catch (e) {
      _setState(ViewState.error, error: e.toString());
    }
  }

  //
  Future<ObjectModel?> fetchObject(String id) async {
    try {
      return await _apiService.getObject(id);
    } catch (e) {
      _setState(ViewState.error, error: e.toString());
      return null;
    }
  }

  Future<bool> createObject(ObjectModel object) async {
    _setState(ViewState.loading);
    try {
      final created = await _apiService.createObject(object);
      _objects = [created, ..._objects];
      _setState(ViewState.idle);
      return true;
    } catch (e) {
      _setState(ViewState.error, error: e.toString());
      return false;
    }
  }

  Future<bool> updateObject(ObjectModel object) async {
    _setState(ViewState.loading);
    try {
      final updated = await _apiService.updateObject(object);
      final index = _objects.indexWhere((o) => o.id == updated.id);
      if (index != -1) _objects[index] = updated;
      _setState(ViewState.idle);
      return true;
    } catch (e) {
      _setState(ViewState.error, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteObject(String id) async {
    _setState(ViewState.loading);
    try {
      await _apiService.deleteObject(id);
      _objects.removeWhere((o) => o.id == id);
      _setState(ViewState.idle);
      return true;
    } catch (e) {
      _setState(ViewState.error, error: e.toString());
      return false;
    }
  }
}
