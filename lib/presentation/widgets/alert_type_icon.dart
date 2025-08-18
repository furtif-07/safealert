import 'package:flutter/material.dart';

class AlertTypeIcon extends StatelessWidget {
  final String type;
  final double size;

  const AlertTypeIcon({Key? key, required this.type, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getTypeIcon(type),
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'theft':
        return Icons.money_off;
      case 'assault':
        return Icons.personal_injury;
      case 'accident':
        return Icons.car_crash;
      case 'fire':
        return Icons.local_fire_department;
      case 'medical':
        return Icons.medical_services;
      case 'disaster':
        return Icons.warning_amber;
      default:
        return Icons.help_outline;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'theft':
        return Colors.indigo;
      case 'assault':
        return Colors.red[700]!;
      case 'accident':
        return Colors.orange[800]!;
      case 'fire':
        return Colors.deepOrange;
      case 'medical':
        return Colors.green[700]!;
      case 'disaster':
        return Colors.purple[800]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
