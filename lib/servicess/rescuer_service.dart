import 'dart:convert';
import '../core/env.dart';
import '../models/rescuer_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sistema_animales/utils/geolocation_helper.dart';

class RescuerService {
  final String baseUrl = '$apiUrl/api/rescatistas';

  Future<List<Rescuer>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['postgres'];

      final lista = data.map((e) => Rescuer.fromJson(e)).toList();

      for (final r in lista) {
        if (r.geolocalizacion != null) {
          await traducirCoordenadasAGoogleMaps(r.geolocalizacion!);
          print('[OK] Rescatista ${r.nombre} -> ${r.geolocalizacion?.descripcion}');

        }
      }
      

      return lista;
    } else {
      throw Exception('Error al obtener rescatistas');
    }
    
  }

  Future<Rescuer> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Rescuer.fromJson(body);
    } else {
      throw Exception('Error al obtener rescatista');
    }
  }

  Future<void> create(Rescuer rescuer, {XFile? imageFile}) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    final Map<String, dynamic> data = rescuer.toJson();
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    if (imageFile != null) {
      final extension = imageFile.path.split('.').last.toLowerCase();
      const allowed = ['jpg', 'jpeg', 'png', 'gif'];

      if (!allowed.contains(extension)) {
        throw Exception('Extensión de archivo no válida: .$extension');
      }

      final bytes = await imageFile.readAsBytes();

      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        bytes,
        filename: 'rescatista_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      final error = await response.stream.bytesToString();
      throw Exception('Error al registrar rescatista: $error');
    }
  }

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

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar rescatista');
    }
  }
}
