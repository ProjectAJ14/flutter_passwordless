import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printEmojis: true,
    noBoxingByDefault: true,
  ),
);
