import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Initialize date formatting for Bahasa Indonesia
void initializeDateLocale() {
  initializeDateFormatting('id_ID', null);
}

String formatDate({DateTime? date, String format = 'EEEE, dd MMMM yyyy'}) {
  // Ensure the date localization is initialized
  initializeDateLocale();

  // Use the provided date or the current date if none is provided
  final DateTime dateTime = date ?? DateTime.now();
  
  // Format the date
  return DateFormat(format, 'id_ID').format(dateTime);
}
