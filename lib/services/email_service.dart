import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static Future<bool> sendContactForm({
    required String name,
    required String email,
    required String company,
    required String message, // AGREGADO
  }) async {
    try {
      print('Enviando formulario...');

      final response = await http.post(
        Uri.parse('https://justiciadministrativa.com/send_email.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'company': company,
          'message': message, // AGREGADO
        }),
      );

      print('Respuesta status: ${response.statusCode}');
      print('Respuesta body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error detallado: $e');
      return false;
    }
  }
}
