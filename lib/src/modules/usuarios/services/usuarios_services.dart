import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/modules/usuarios/models/insert_usuarios_model.dart';
import 'package:app_gestao/src/modules/usuarios/models/usuarios_model.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  final List<UsuariosModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class UsuariosServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  UsuariosServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(String search, int page, int limit) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.usuariosRead(search, page, limit),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<UsuariosModel> data = [
        ...res.data['data'].map(
          (e) => UsuariosModel(
            id: e['id'],
            email: e['email'],
            root: e['root'],
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

  Future<ErrorModel?> insert(InsertUsuariosModel modelo) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.usuariosInsert(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          ...modelo.toMap(),
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    }
  }

  Future<ErrorModel?> delete(List<String> listaIds) async {
    try {
      await _apiProvider.dio.delete(
        ApiRoutes.usuariosDelete(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'listaIds': listaIds,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    }
  }

  Future<({InsertUsuariosModel? data, ErrorModel? error})> readById(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.usuariosReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final InsertUsuariosModel data = InsertUsuariosModel(
        id: res.data['id'],
        email: res.data['email'],
        senha: res.data['senha'],
        listaPermissoes: res.data['listaPermissoes'],
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
