export 'logger.dart';

extension StringExtension on String {
  String clearLocalityPrefix() {
    if (contains('Kecamatan')) {
      return replaceAll('Kecamatan', '').trim();
    } else if (contains('Kabupaten')) {
      return replaceAll('Kabupaten', '').trim();
    } else if (contains('Kota')) {
      return replaceAll('Kota', '').trim();
    } else {
      return this;
    }
  }
}
