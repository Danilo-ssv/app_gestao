import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  // final List<CategoriasProdutosModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    // required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class HomeServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  HomeServices(this._localStorageProvider, this._apiProvider);

  Future<ErrorModel?> home() async {
    try {
      await _apiProvider.dio.get(
        ApiRoutes.home(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn(err.toString());
    }
  }
}
