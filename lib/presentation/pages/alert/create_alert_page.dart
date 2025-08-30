import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safealert/presentation/bloc/auth/auth_bloc.dart';
import 'package:safealert/presentation/bloc/alert/alert_bloc.dart';
import 'package:safealert/core/constants/app_theme.dart';
import 'package:safealert/core/utils/location_service.dart';

class CreateAlertPage extends StatefulWidget {
  const CreateAlertPage({Key? key}) : super(key: key);

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedType = 'theft';
  Position? _currentPosition;
  bool _isLoading = false;
  bool _isLocationLoading = true;

  final Map<String, String> _alertTypes = {
    'theft': 'Vol',
    'assault': 'Agression',
    'accident': 'Accident',
    'fire': 'Incendie',
    'medical': 'Urgence médicale',
    'disaster': 'Catastrophe naturelle',
    'other': 'Autre',
  };

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLocationLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLocationLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'obtenir votre position: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitAlert() {
    if (_formKey.currentState!.validate()) {
      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Position non disponible. Veuillez réessayer.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final authState = context.read<AuthBloc>().state;
      if (authState is AuthenticatedState) {
        context.read<AlertBloc>().add(
              CreateAlertEvent(
                title: _alertTypes[_selectedType] ?? 'Alerte',
                description: _descriptionController.text,
                type: _selectedType,
                latitude: _currentPosition!.latitude,
                longitude: _currentPosition!.longitude,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler une urgence'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: BlocListener<AlertBloc, AlertState>(
        listener: (context, state) {
          if (state is AlertCreated) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Alerte envoyée avec succès!'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is AlertError) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Type d\'urgence',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          items: _alertTypes.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedType = value;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner un type d\'urgence';
                            }
                            return null;
                          },
                        ),
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
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Décrivez la situation...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez fournir une description';
                            }
                            if (value.length < 10) {
                              return 'La description doit contenir au moins 10 caractères';
                            }
                            return null;
                          },
                        ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Localisation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_isLocationLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppTheme.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _currentPosition != null
                                    ? Text(
                                        'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}\nLongitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    : const Text(
                                        'Position non disponible',
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _getCurrentLocation,
                                tooltip: 'Actualiser la position',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitAlert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'SIGNALER L\'URGENCE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Note: Les fausses alertes sont punies par la loi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
