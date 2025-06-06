class Adoption {
  final String? id;
  final String? animalId;
  final String nombreAnimal;
  final String? estado;
  final String? nombreAdoptante;
  final String? contactoAdoptante;
  final String? direccionAdoptante;
  final String? observaciones;
  final DateTime fechaAdopcion;
  final double? latitud;
  final double? longitud;
  final String? descripcion;

  Adoption({
    this.id,
    this.animalId,
    required this.nombreAnimal,
    this.estado,
    this.nombreAdoptante,
    this.contactoAdoptante,
    this.direccionAdoptante,
    this.observaciones,
    required this.fechaAdopcion,
    this.latitud,
    this.longitud,
    this.descripcion,
  });

  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
      id: json['id'],
      animalId: json['animalId'],
      nombreAnimal: json['animal']?['nombre'] ?? json['nombreAnimal'],
      estado: json['estado'],
      nombreAdoptante: json['nombreAdoptante'],
      contactoAdoptante: json['contactoAdoptante'],
      direccionAdoptante: json['direccionAdoptante'],
      observaciones: json['observaciones'],
      fechaAdopcion: DateTime.parse(json['fechaAdopcion']),
      latitud: json['latitud']?.toDouble(),
      longitud: json['longitud']?.toDouble(),
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreAnimal': nombreAnimal,
      'estado': estado,
      'nombreAdoptante': nombreAdoptante,
      'contactoAdoptante': contactoAdoptante,
      'direccionAdoptante': direccionAdoptante,
      'observaciones': observaciones,
      'fechaAdopcion': fechaAdopcion.toIso8601String(),
      'latitud': latitud,
      'longitud': longitud,
      'descripcion': descripcion,
    };
  }
}
