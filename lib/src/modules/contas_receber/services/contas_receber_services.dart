import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/modules/contas_receber/models/contas_receber_model.dart';
import 'package:app_gestao/src/modules/contas_receber/models/insert_contas_receber_model.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class ReadReturnModel {
  final List<ContasReceberModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class ContasReceberServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  ContasReceberServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(
    String search,
    int page,
    int limit,
    String startDate,
    String endDate,
    String status,
  ) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.contasReceberRead(search, page, limit, startDate, endDate, status),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<ContasReceberModel> data = [
        ...res.data['data'].map(
          (e) {
            final dataVencimento = (e['dataVencimento'] as String).split('-');

            return ContasReceberModel(
              id: e['id'],
              dataVencimento: dataVencimento.length != 3 ? '' : '${dataVencimento[2]}/${dataVencimento[1]}/${dataVencimento[0]}',
              nomeClientes: e['nomeClientes'],
              descricao: e['descricao'],
              valor: CurrencyFormatterFunction.format(e['valor'] as String, showSymbol: true),
              status: e['status'],
              nomeStatus: e['nomeStatus'],
              color: e['color'],
            );
          },
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

  Future<ErrorModel?> insert(InsertContasReceberModel modelo) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.contasReceberInsert(),
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
        ApiRoutes.contasReceberDelete(),
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

  Future<({InsertContasReceberModel? data, ErrorModel? error})> readById(String id) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.contasReceberReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final dataEmissao = (res.data['dataEmissao'] as String).split('-');
      final dataVencimento = (res.data['dataVencimento'] as String).split('-');

      final InsertContasReceberModel data = InsertContasReceberModel(
        id: res.data['id'],
        idClientes: res.data['idClientes'],
        nomeClientes: res.data['nomeClientes'],
        dataEmissao: dataEmissao.length != 3 ? '' : '${dataEmissao[2]}/${dataEmissao[1]}/${dataEmissao[0]}',
        dataVencimento: dataVencimento.length != 3 ? '' : '${dataVencimento[2]}/${dataVencimento[1]}/${dataVencimento[0]}',
        descricao: res.data['descricao'],
        valor: CurrencyFormatterFunction.format(res.data['valor'] as String),
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

  Future<ErrorModel?> writeOff(String id, String dataBaixa, String desconto) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.contasReceberWriteOff(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'id': id,
          'dataBaixa': dataBaixa,
          'desconto': desconto,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn(err.toString());
    }
  }

  Future<ErrorModel?> parcelling(String id, int parcelas, int frequencia) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.contasReceberParcelling(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'id': id,
          'parcelas': parcelas,
          'frequencia': frequencia,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn(err.toString());
    }
  }
}
