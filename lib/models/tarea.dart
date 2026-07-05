import 'package:cloud_firestore/cloud_firestore.dart';

class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final DateTime fecha;
  final String prioridad;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.completada,
    required this.fecha,
    required this.prioridad,
  });

  factory Tarea.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Tarea(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      completada: data['completada'] ?? false,
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      prioridad: data['prioridad'] ?? 'Media',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada,
      'fecha': Timestamp.fromDate(fecha),
      'prioridad': prioridad,
    };
  }
}
