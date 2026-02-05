import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiProvider {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      connectTimeout: const Duration(seconds: 60),
      extra: {'withCredentials': true},
    ),
  );
}
