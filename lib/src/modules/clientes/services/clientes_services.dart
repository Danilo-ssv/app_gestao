import 'package:app_gestao/src/modules/clientes/models/clientes_model.dart';
import 'package:app_gestao/src/modules/clientes/models/insert_clientes_model.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  final List<ClientesModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class ClientesServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  ClientesServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(String search, int page, int limit) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.clientesRead(search, page, limit),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<ClientesModel> data = [
        ...res.data['data'].map(
          (e) => ClientesModel(
            id: e['id'],
            nome: e['nome'],
            celular: e['celular'],
            email: e['email'],
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

  Future<ErrorModel?> insert(InsertClientesModel modelo) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.clientesInsert(),
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
        ApiRoutes.clientesDelete(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'listaIds': listaIds,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn(err.toString());
    }
  }

  Future<({InsertClientesModel? data, ErrorModel? error})> readById(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.clientesReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final aniversario = (res.data['aniversario'] as String).split('-');

      final InsertClientesModel data = InsertClientesModel(
        id: res.data['id'],
        nome: res.data['nome'],
        estadoCivil: ClientesEstadoCivil.$1.formatToEnum(res.data['estadoCivil']),
        genero: ClientesGenero.$1.formatToEnum(res.data['genero']),
        entidade: ClientesEntidade.$1.formatToEnum(res.data['entidade']),
        aniversario: aniversario.length != 3 ? '' : '${aniversario[2]}/${aniversario[1]}/${aniversario[0]}',
        doc: res.data['doc'],
        rg: res.data['rg'],
        celular: res.data['celular'],
        email: res.data['email'],
        cep: res.data['cep'],
        endereco: res.data['endereco'],
        numero: res.data['numero'],
        idMunicipios: res.data['idMunicipios'],
        nomeMunicipios: res.data['nomeMunicipios'],
        obs: res.data['obs'],
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
