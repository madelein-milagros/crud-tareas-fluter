import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarea.dart';
import 'form_tarea_screen.dart';

class ListaTareasScreen extends StatefulWidget {
  const ListaTareasScreen({super.key});

  @override
  State<ListaTareasScreen> createState() => _ListaTareasScreenState();
}

class _ListaTareasScreenState extends State<ListaTareasScreen> {
  String _searchQuery = '';
  String _filter = 'Todas'; // 'Todas', 'Pendientes', 'Completadas'

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade100;
      case 'Baja':
        return Colors.green.shade100;
      case 'Media':
      default:
        return Colors.yellow.shade100;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Alta':
        return Icons.keyboard_double_arrow_up;
      case 'Baja':
        return Icons.keyboard_double_arrow_down;
      case 'Media':
      default:
        return Icons.drag_handle;
    }
  }

  Color _getPriorityIconColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red.shade700;
      case 'Baja':
        return Colors.green.shade700;
      case 'Media':
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: ['Todas', 'Pendientes', 'Completadas'].map((String filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _filter == filter,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _filter = filter;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tareas').orderBy('fecha', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar las tareas'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No hay tareas pendientes. ¡Agrega una!'),
                  );
                }

                // Obtener y parsear todas las tareas
                final todasLasTareas = snapshot.data!.docs
                    .map((doc) => Tarea.fromFirestore(doc))
                    .toList();

                // Dashboard stats
                final totalTareas = todasLasTareas.length;
                final completadas = todasLasTareas.where((t) => t.completada).length;
                final progreso = totalTareas > 0 ? completadas / totalTareas : 0.0;

                // Aplicar filtros locales
                final tareasFiltradas = todasLasTareas.where((tarea) {
                  // Filtro por texto
                  final matchesSearch = tarea.titulo.toLowerCase().contains(_searchQuery) ||
                                        tarea.descripcion.toLowerCase().contains(_searchQuery);

                  // Filtro por estado
                  bool matchesStatus = true;
                  if (_filter == 'Pendientes') {
                    matchesStatus = !tarea.completada;
                  } else if (_filter == 'Completadas') {
                    matchesStatus = tarea.completada;
                  }

                  return matchesSearch && matchesStatus;
                }).toList();

                return Column(
                  children: [
                    // Dashboard de progreso
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Progreso',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    '$completadas de $totalTareas',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progreso,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: Colors.grey.shade300,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Mini-tarjetas de estadísticas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Pendientes',
                              value: (totalTareas - completadas).toString(),
                              color: Colors.orange.shade100,
                              textColor: Colors.orange.shade800,
                              icon: Icons.pending_actions,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatCard(
                              label: 'Completadas',
                              value: completadas.toString(),
                              color: Colors.green.shade100,
                              textColor: Colors.green.shade800,
                              icon: Icons.check_circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatCard(
                              label: 'Alta prioridad',
                              value: todasLasTareas.where((t) => t.prioridad == 'Alta').length.toString(),
                              color: Colors.red.shade100,
                              textColor: Colors.red.shade800,
                              icon: Icons.keyboard_double_arrow_up,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Lista de tareas
                    Expanded(
                      child: tareasFiltradas.isEmpty
                          ? const Center(child: Text('No se encontraron tareas con estos filtros.'))
                          : ListView.builder(
                              itemCount: tareasFiltradas.length,
                              itemBuilder: (context, index) {
                                final tarea = tareasFiltradas[index];

                                return Dismissible(
                                  key: Key(tarea.id),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmar eliminación"),
                                          content: const Text("¿Estás seguro de que deseas eliminar esta tarea?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Cancelar"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text("Eliminar"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) {
                                    FirebaseFirestore.instance.collection('tareas').doc(tarea.id).delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tarea eliminada')),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: _getPriorityColor(tarea.prioridad),
                                        width: 2,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.only(left: 8, right: 16, top: 4, bottom: 4),
                                      leading: Checkbox(
                                        value: tarea.completada,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            FirebaseFirestore.instance
                                                .collection('tareas')
                                                .doc(tarea.id)
                                                .update({'completada': value});
                                          }
                                        },
                                      ),
                                      title: Text(
                                        tarea.titulo,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: tarea.completada ? TextDecoration.lineThrough : null,
                                          color: tarea.completada ? Colors.grey : null,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (tarea.descripcion.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                              child: Text(
                                                tarea.descripcion,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration: tarea.completada ? TextDecoration.lineThrough : null,
                                                  color: tarea.completada ? Colors.grey : null,
                                                ),
                                              ),
                                            ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${tarea.fecha.day.toString().padLeft(2, '0')}/${tarea.fecha.month.toString().padLeft(2, '0')}/${tarea.fecha.year}',
                                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                _getPriorityIcon(tarea.prioridad),
                                                size: 16,
                                                color: _getPriorityIconColor(tarea.prioridad),
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                tarea.prioridad,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: _getPriorityIconColor(tarea.prioridad),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FormTareaScreen(tarea: tarea),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormTareaScreen(),
            ),
          );
        },
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}