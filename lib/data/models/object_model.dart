// Model class representing an Object from the API.
class ObjectModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  ObjectModel({required this.id, required this.name, this.data});

  // Factory constructor used when converting JSON → Dart object
  factory ObjectModel.fromJson(Map<String, dynamic> json) {
    return ObjectModel(
      // API may return id as int or string → convert safely to String
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unnamed',
      // Convert nested JSON map safely
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }
  // Convert Dart object → JSON
  // Used when sending POST/PUT request to API
  Map<String, dynamic> toJson() {
    // Send data only if it exists
    return {'name': name, if (data != null) 'data': data};
  }

  // copyWith is used to create a modified copy of object
  ObjectModel copyWith({String? id, String? name, Map<String, dynamic>? data}) {
    return ObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}
