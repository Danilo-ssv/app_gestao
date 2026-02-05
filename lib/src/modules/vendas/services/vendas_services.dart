import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/modules/vendas/models/insert_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/models/itens_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/models/lista_categorias_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/models/vendas_model.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/models/image_model.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  final List<VendasModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class VendasServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  VendasServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(
    String search,
    int page,
    int limit,
    String startDate,
    String endDate,
    String status,
    String idClientes,
  ) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.vendasRead(search, page, limit, startDate, endDate, status, idClientes),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<VendasModel> data = [
        ...res.data['data'].map(
          (e) => VendasModel(
            id: e['id'],
            nomeClientes: e['nomeClientes'],
            valorTotal: CurrencyFormatterFunction.format(e['valorTotal'] as String, showSymbol: true),
            dataModificacao: e['dataModificacao'],
            status: e['status'],
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

  Future<ErrorModel?> insert(InsertVendasModel modelo, List<Map<String, String>> updatedProdutos) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.vendasInsert(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          ...modelo.toMap(),
          'updatedProdutos': updatedProdutos,
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
        ApiRoutes.vendasDelete(),
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

  Future<({List<ListaCategoriasVendasModel>? listaCategorias, InsertVendasModel? data, ErrorModel? error})> readById(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.vendasReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<ListaCategoriasVendasModel> listaCategorias = [
        ...res.data['listaCategorias'].map(
          (e) => ListaCategoriasVendasModel(
            id: e['id'],
            nome: e['nome'],
            produtos: [
              ...e['produtos'].map(
                (el) => ProdutosListaCategoriasVendasModel(
                  id: el['id'],
                  nome: el['nome'],
                  preco: CurrencyFormatterFunction.format(el['preco'] as String, showSymbol: true),
                  estoque: el['estoque'],
                  image: el['image'] == null
                      ? null
                      : ImageModel(
                          imageOrigin: ImageOrigin.network,
                          name: el['image']['name'],
                          urlPath: el['image']['urlPath'],
                          path: null,
                          bytes: null,
                        ),
                ),
              ),
            ],
          ),
        ),
      ];

      InsertVendasModel? data;

      if (res.data['data'] != null) {
        data = InsertVendasModel(
          id: res.data['data']['id'],
          idClientes: res.data['data']['idClientes'],
          nomeClientes: res.data['data']['nomeClientes'],
          valorTotal: res.data['data']['valorTotal'],
          listaItensVendas: [
            ...res.data['data']['listaItensVendas'].map(
              (e) => ItensVendasModel(
                id: e['id'],
                idProdutos: e['idProdutos'],
                nomeProdutos: e['nomeProdutos'],
                quantidade: e['quantidade'],
                valor: e['valor'],
                isSelect: false,
                deleting: false,
              ),
            ),
          ],
        );
      }

      return (listaCategorias: listaCategorias, data: data, error: null);
    } on DioException catch (err) {
      return (
        listaCategorias: null,
        data: null,
        error: errorReturn(err.response?.data ?? 'Erro Inesperado'),
      );
    } catch (err) {
      return (listaCategorias: null, data: null, error: errorReturn(err.toString()));
    }
  }

  Future<({String? idClientes, String? nomeClientes, ErrorModel? error})> readForFinalize(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.vendasReadForFinalize(id),
      );

      final String idClientes = res.data['idClientes'];
      final String nomeClientes = res.data['nomeClientes'];

      return (idClientes: idClientes, nomeClientes: nomeClientes, error: null);
    } on DioException catch (err) {
      return (idClientes: null, nomeClientes: null, error: errorReturn((err.response?.data ?? 'Erro Inesperado').toString()));
    } catch (err) {
      return (idClientes: null, nomeClientes: null, error: errorReturn(err.toString()));
    }
  }

  Future<ErrorModel?> finalize(String id, String idClientes, String desconto, String acrescimo, String dataVencimento) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.vendasFinalize(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'id': id,
          'idClientes': idClientes,
          'desconto': desconto,
          'acrescimo': acrescimo,
          'dataVencimento': dataVencimento,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn((err.response?.data ?? 'Erro Inesperado').toString());
    } catch (err) {
      return errorReturn(err.toString());
    }
  }

  Future<({InsertVendasModel? data, ErrorModel? error})> readForDetails(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.vendasReadForDetails(id),
      );

      // print(res.data['listaItensVendas']);
      // print(res.data['listaItensVendas'][0]['valor'].runtimeType);

      final data = InsertVendasModel(
        id: res.data['id'],
        idClientes: res.data['idClientes'],
        nomeClientes: res.data['nomeClientes'],
        valorTotal: res.data['valorTotal'],
        listaItensVendas: [
          ...res.data['listaItensVendas'].map(
            (e) => ItensVendasModel(
              id: e['id'],
              idProdutos: e['idProdutos'],
              nomeProdutos: e['nomeProdutos'],
              quantidade: e['quantidade'],
              valor: e['valor'],
              isSelect: false,
              deleting: false,
            ),
          ),
        ],
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
