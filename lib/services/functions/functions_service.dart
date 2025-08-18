import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _functions;

  FunctionsService(this._functions);

  Future<Map<String, dynamic>> callFunction(String name, Map<String, dynamic> data) async {
    try {
      final callable = _functions.httpsCallable(name);
      final result = await callable.call(data);
      return result.data;
    } catch (e) {
      throw Exception('Erreur lors de l\'appel de la fonction: $e');
    }
  }
}