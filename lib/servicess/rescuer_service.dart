import 'dart:convert';
import '../core/env.dart';
import '../models/rescuer_model.dart';
import 'package:http/http.dart' as http;

class RescuerService {
  final String baseUrl = '$apiUrl/api/rescatistas';

  /// Obtener todos los rescatistas (solo desde SQL)
  Future<List<Rescuer>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['postgres']; // SQL
      return data.map((e) => Rescuer.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener rescatistas');
    }
  }

  /// Obtener un rescatista por ID
  Future<Rescuer> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Rescuer.fromJson(body);
    } else {
      throw Exception('Error al obtener rescatista');
    }
  }

  /// Crear un nuevo rescatista
  Future<void> create(Rescuer rescuer) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rescuer.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al registrar rescatista');
    }
  }

  /// Actualizar un rescatista
  Future<void> update(String id, Rescuer rescuer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rescuer.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar rescatista');
    }
  }

  /// Eliminar un rescatista
  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar rescatista');
    }
  }
}
