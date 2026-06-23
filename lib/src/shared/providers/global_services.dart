import 'package:app_gestao/src/shared/models/global_hf_escolas_model.dart';
import 'package:app_gestao/src/shared/models/global_marcas_produtos_model.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/models/global_fornecedores_model.dart';
import 'package:app_gestao/src/shared/models/global_categorias_produtos_model.dart';
import 'package:app_gestao/src/shared/models/global_clientes_model.dart';
import 'package:app_gestao/src/shared/models/global_despesas_model.dart';
import 'package:app_gestao/src/shared/models/global_municipios_model.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class GlobalServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  GlobalServices(this._localStorageProvider, this._apiProvider);

  Future<({List<GlobalMunicipiosModel>? data, ErrorModel? error})> readMunicipios(String search, String uf) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadMunicipios(search, uf),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalMunicipiosModel> data = [
        ...res.data.map(
          (e) => GlobalMunicipiosModel(
            id: e['id'],
            codigo: e['codigo'],
            nome: e['nome'],
            uf: e['uf'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalFornecedoresModel>? data, ErrorModel? error})> readFornecedores(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadFornecedores(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalFornecedoresModel> data = [
        ...res.data.map(
          (e) => GlobalFornecedoresModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalCategoriasProdutosModel>? data, ErrorModel? error})> readCategoriasProdutos(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadCategoriasProdutos(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalCategoriasProdutosModel> data = [
        ...res.data.map(
          (e) => GlobalCategoriasProdutosModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalDespesasModel>? data, ErrorModel? error})> readDespesas(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadDespesas(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalDespesasModel> data = [
        ...res.data.map(
          (e) => GlobalDespesasModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalClientesModel>? data, ErrorModel? error})> readClientes(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadClientes(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalClientesModel> data = [
        ...res.data.map(
          (e) => GlobalClientesModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalHfEscolasModel>? data, ErrorModel? error})> readHfEscolas(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadHfEscolas(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalHfEscolasModel> data = [
        ...res.data.map(
          (e) => GlobalHfEscolasModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({List<GlobalMarcasProdutosModel>? data, ErrorModel? error})> readMarcasProdutos(String search) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.globalReadMarcasProdutos(search),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<GlobalMarcasProdutosModel> data = [
        ...res.data.map(
          (e) => GlobalMarcasProdutosModel(
            id: e['id'],
            nome: e['nome'],
          ),
        ),
      ];
      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertFornecedores(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertFornecedores(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertCategoriasProdutos(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertCategoriasProdutos(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertDespesas(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertDespesas(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertClientes(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertClientes(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertHfEscolas(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertHfEscolas(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? id, ErrorModel? error})> insertMarcasProdutos(String nome) async {
    try {
      final res = await _apiProvider.dio.post(
        ApiRoutes.globalInsertMarcasProdutos(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'nome': nome,
        },
      );

      final String id = res.data;

      return (id: id, error: null);
    } on DioException catch (err) {
      return (id: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (id: null, error: errorReturn(err.toString()));
    }
  }
}
