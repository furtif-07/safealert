import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safealert/core/constants/app_theme.dart';
import 'package:safealert/domain/entities/alert_entity.dart';
import 'package:safealert/presentation/bloc/alert/alert_bloc.dart';
import 'package:intl/intl.dart';

class AlertDetailsPage extends StatefulWidget {
  final String alertId;

  const AlertDetailsPage({Key? key, required this.alertId}) : super(key: key);

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlertBloc>().add(LoadAlertDetailsEvent(widget.alertId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'alerte'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AlertDetailsLoaded) {
            return _buildAlertDetails(context, state.alert);
          } else if (state is AlertError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlertBloc>().add(
                            LoadAlertDetailsEvent(widget.alertId),
                          );
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Aucune information disponible'),
            );
          }
        },
      ),
    );
  }

  Widget _buildAlertDetails(BuildContext context, AlertEntity alert) {
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getAlertColor(alert.type),
                        child: Icon(
                          _getAlertIcon(alert.type),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getAlertTypeLabel(alert.type),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Signalé le ${dateFormat.format(alert.createdAt)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(_getStatusLabel(alert.status)),
                        backgroundColor: _getStatusColor(alert.status),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (alert.priority >= 3) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.priority_high, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Priorité ${_getPriorityLabel(alert.priority)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Localisation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildMapPreview(alert),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getLocationText(alert),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                         
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Ouvrir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (alert.imageUrls != null && alert.imageUrls!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Médias',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('${alert.imageUrls!.length} fichier(s) attaché(s)'),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Statut actuel'),
                    subtitle: Text(_getStatusLabel(alert.status)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Créé le'),
                    subtitle: Text(dateFormat.format(alert.createdAt)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('Mis à jour le'),
                    subtitle: Text(dateFormat.format(alert.updatedAt)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMapPreview(AlertEntity alert) {
    // Placeholder pour la carte
    // Dans une implémentation réelle, utilisez Google Maps ou une autre solution
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            'Carte de la position',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'emergency':
        return Colors.red;
      case 'fire':
        return Colors.deepOrange;
      case 'medical':
        return Colors.pink;
      case 'crime':
        return Colors.purple;
      case 'accident':
        return Colors.amber;
      case 'natural_disaster':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'emergency':
        return Icons.emergency;
      case 'fire':
        return Icons.local_fire_department;
      case 'medical':
        return Icons.medical_services;
      case 'crime':
        return Icons.security;
      case 'accident':
        return Icons.car_crash;
      case 'natural_disaster':
        return Icons.warning_amber;
      default:
        return Icons.info;
    }
  }

  String _getLocationText(AlertEntity alert) {
    if (alert.address != null && alert.address!.isNotEmpty) {
      return alert.address!;
    }
    return 'Lat: ${alert.latitude.toStringAsFixed(6)}, Lng: ${alert.longitude.toStringAsFixed(6)}';
  }

  String _getAlertTypeLabel(String type) {
    switch (type) {
      case 'emergency':
        return 'Urgence';
      case 'fire':
        return 'Incendie';
      case 'medical':
        return 'Médical';
      case 'crime':
        return 'Crime';
      case 'accident':
        return 'Accident';
      case 'natural_disaster':
        return 'Catastrophe naturelle';
      default:
        return 'Alerte';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmé';
      case 'in_progress':
        return 'En cours';
      case 'resolved':
        return 'Résolu';
      case 'false_alarm':
        return 'Fausse alerte';
      default:
        return 'Inconnu';
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Faible';
      case 2:
        return 'Normale';
      case 3:
        return 'Élevée';
      case 4:
        return 'Critique';
      default:
        return 'Normale';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange[100]!;
      case 'confirmed':
        return Colors.blue[100]!;
      case 'in_progress':
        return Colors.yellow[100]!;
      case 'resolved':
        return Colors.green[100]!;
      case 'false_alarm':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}
