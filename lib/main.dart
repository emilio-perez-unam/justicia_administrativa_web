import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/app.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- ADDED IMPORT

void main() async {
  // <-- MODIFIED TO BE ASYNC
  // Ensure Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for the Spanish (Mexico) locale.
  await initializeDateFormatting('es_MX', null); // <-- ADDED INITIALIZATION

  // Remove the hash (#) from URLs for cleaner web URLs
  setPathUrlStrategy();

  runApp(const JusticiaAdministrativaApp());
}
