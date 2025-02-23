class MarkerModel {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;

  MarkerModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Método para convertir a Map (útil para Firebase o almacenamiento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  // Método para crear una instancia desde un Map (ej. JSON o BD)
  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
