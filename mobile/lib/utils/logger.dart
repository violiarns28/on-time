import 'package:logger/web.dart';

final log = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: (time) => time.toIso8601String(),
  ),
);
