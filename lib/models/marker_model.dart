class MarkerModel {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String iconName;
  final bool isApproved;
  MarkerModel(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.iconName,
      required this.isApproved});

  // Método para convertir a Map (útil para Firebase o almacenamiento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'iconName': iconName,
      'isApproved': isApproved
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
        startDate: map['startDate'],
        endDate: map['endDate'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        iconName: map['iconName'],
        isApproved: map['isApproved']);
  }

  // Método para copiar el modelo con cambios
  MarkerModel copyWith({bool? isApproved}) {
    return MarkerModel(
      id: id,
      latitude: latitude,
      longitude: longitude,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      iconName: iconName,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}
