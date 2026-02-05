import 'package:app_gestao/src/modules/marcas_produtos/models/insert_marcas_produtos_model.dart';
import 'package:app_gestao/src/modules/marcas_produtos/models/marcas_produtos_model.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  final List<MarcasProdutosModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class MarcasProdutosServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  MarcasProdutosServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(String search, int page, int limit) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.marcasProdutosRead(search, page, limit),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<MarcasProdutosModel> data = [
        ...res.data['data'].map(
          (e) => MarcasProdutosModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];

      final int numberOfPages = res.data['numberOfPages'];

      return ReadReturnModel(data: data, numberOfPages: numberOfPages, error: null);
    } on DioException catch (err) {
      return ReadReturnModel(
        data: null,
        numberOfPages: null,
        error: errorReturn(err.response?.data ?? 'Erro Inesperado'),
      );
    } catch (err) {
      return ReadReturnModel(data: null, numberOfPages: null, error: errorReturn(err.toString()));
    }
  }

  Future<ErrorModel?> insert(InsertMarcasProdutosModel modelo) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.marcasProdutosInsert(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          ...modelo.toMap(),
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn(err.toString());
    }
  }

  Future<ErrorModel?> delete(List<String> listaIds) async {
    try {
      await _apiProvider.dio.delete(
        ApiRoutes.marcasProdutosDelete(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'listaIds': listaIds,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn((err.response?.data ?? 'Erro Inesperado').toString());
    } catch (err) {
      return errorReturn(err.toString());
    }
  }

  Future<({InsertMarcasProdutosModel? data, ErrorModel? error})> readById(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.marcasProdutosReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final InsertMarcasProdutosModel data = InsertMarcasProdutosModel(
        id: res.data['id'],
        nome: res.data['nome'],
      );

      return (data: data, error: null);
    } on DioException catch (err) {
      return (
        data: null,
        error: errorReturn(err.response?.data ?? 'Erro Inesperado'),
      );
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }
}
