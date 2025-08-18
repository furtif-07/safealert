import 'package:flutter/material.dart';

class AlertStatusBadge extends StatelessWidget {
  final String status;

  const AlertStatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusLabel(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'created':
        return Colors.blue;
      case 'received':
        return Colors.orange;
      case 'assigned':
        return Colors.purple;
      case 'in_progress':
        return Colors.amber[800]!;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'created':
        return 'CRÉÉE';
      case 'received':
        return 'REÇUE';
      case 'assigned':
        return 'ASSIGNÉE';
      case 'in_progress':
        return 'EN COURS';
      case 'resolved':
        return 'RÉSOLUE';
      case 'closed':
        return 'CLÔTURÉE';
      default:
        return 'INCONNU';
    }
  }
}
