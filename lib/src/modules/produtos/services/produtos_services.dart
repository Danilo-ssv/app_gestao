import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:app_gestao/src/shared/models/file_model.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/modules/produtos/models/insert_produtos_model.dart';
import 'package:app_gestao/src/modules/produtos/models/produtos_model.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;

class ReadReturnModel {
  final List<ProdutosModel>? data;
  final int? numberOfPages;
  final ErrorModel? error;

  ReadReturnModel({
    required this.data,
    required this.numberOfPages,
    required this.error,
  });
}

class ProdutosServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  ProdutosServices(this._localStorageProvider, this._apiProvider);

  Future<ReadReturnModel> read(String search, int page, int limit) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.produtosRead(search, page, limit),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final List<ProdutosModel> data = [
        ...res.data['data'].map(
          (e) => ProdutosModel(
            id: e['id'],
            codigo: e['codigo'],
            nome: e['nome'],
            preco: CurrencyFormatterFunction.format(e['preco'] as String, showSymbol: true),
            estoque: e['estoque'],
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

  Future<ErrorModel?> insert(InsertProdutosModel modelo) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.produtosInsert(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: FormData.fromMap({
          ...modelo.toMap(),
          if (modelo.image?.path != null) ...{
            'file': await MultipartFile.fromFile(modelo.image!.path!),
          }
        }, ListFormat.multiCompatible),
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn('Erro Inesperado');
    }
  }

  Future<ErrorModel?> delete(List<String> listaIds) async {
    try {
      await _apiProvider.dio.delete(
        ApiRoutes.produtosDelete(),
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

  Future<({InsertProdutosModel? data, ErrorModel? error})> readById(String id, String _codigoBarra) async {
    try {
      final res = await _apiProvider.dio.get(
        ApiRoutes.produtosReadById(id),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
      );

      final InsertProdutosModel data = InsertProdutosModel(
        id: res.data['id'],
        codigoBarra: res.data['codigoBarra'],
        codigo: res.data['codigo'],
        nome: res.data['nome'],
        descricao: res.data['descricao'],
        preco: CurrencyFormatterFunction.format(res.data['preco'] as String),
        custo: CurrencyFormatterFunction.format(res.data['custo'] as String),
        estoque: res.data['estoque'],
        idMarcasProdutos: res.data['idMarcasProdutos'],
        nomeMarcasProdutos: res.data['nomeMarcasProdutos'],
        idCategoriasProdutos: res.data['idCategoriasProdutos'],
        nomeCategoriasProdutos: res.data['nomeCategoriasProdutos'],
        alertaEstoqueMinimo: res.data['alertaEstoqueMinimo'],
        genero: ProdutosGenero.$1.formatToEnum(res.data['genero']),
        image: res.data['image'] == ''
            ? null
            : FileModel(
                fileOrigin: FileOrigin.network,
                urlPath: res.data['image'],
                path: null,
              ),
      );

      return (data: data, error: null);
    } on DioException catch (err) {
      return (data: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (data: null, error: errorReturn(err.toString()));
    }
  }

  Future<ErrorModel?> insertBaixaEstoque(String idProdutos, int estoque, String dataBaixa) async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.produtosInsertBaixaEstoque(),
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        data: {
          'idProdutos': idProdutos,
          'estoque': estoque,
          'dataBaixa': dataBaixa,
        },
      );

      return null;
    } on DioException catch (err) {
      return errorReturn(err.response?.data ?? 'Erro Inesperado');
    } catch (err) {
      return errorReturn('Erro Inesperado');
    }
  }

  Future<(({String nome, String preco})?, ErrorModel?)> readByBarsCode(String codigoBarra) async {
// //     try {
// //       print('https://www.americanas.com.br/busca/$codigoBarra/');

// //       final res1 = await Dio().get(
// //         // 'https://cors-anywhere.herokuapp.com/' +
// //         'https://www.americanas.com.br/busca/$codigoBarra/',
// //         // 'https://www.amazon.com.br/s?k=7908132275446',
// //         // options: Options(
// //         //   headers: {
// //         //     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
// //         //     'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
// //         //   },
// //         // ),
// //       );
// //       final document1 = parse(res1.data);

// // print('AQUI');

// //       // var nome = document1.querySelector('.inStockCard__Link-sc-1ngt5zo-1 .styles__Name-sc-1e4r445-0')?.text;
// //       // var preco = document1.querySelector('.inStockCard__Link-sc-1ngt5zo-1 .src__Text-sc-154pg0p-0')?.text;

// //       // print('Title: $nome');
// //       // print('H1: $preco');

// //       return (null, null);
// //     } on DioException catch (err) {
// //       print(err.response);
// //       print(err.message);
// //       return (
// //         null,
// //         errorReturn('Erro Inesperado'),
// //         // errorReturn(err.response?.data ?? 'Erro Inesperado'),
// //       );
// //     } catch (err) {
// //       return (null, errorReturn(err.toString()));
// //     }
//     try {
//       final uri = Uri.https('www.amazon.com.br', 's', {
//         'k': codigoBarra,
//       });
//       print(uri);
//       final res1 = await http.get(uri);
//       // final res1 = await http.get(Uri.https('www.americanas.com.br', 'busca/$codigoBarra'));
//       final html1 = dom.Document.html(res1.body);

//       print(html1.body!.children.map((e) => print(e.innerHtml)).toList());
//       // print(html1.body!.children[0].innerHtml);
// // print(html1.body!.children[1].innerHtml);
// // print(html1.body!.children[2].innerHtml);
// // print(html1.body!.children[3].innerHtml);

//       // print(html1.body?.querySelectorAll('.sg-col-inner'));
//       // print(html1.body?.querySelectorAll('.puis-card-container'));

// // puis-card-container s-card-container s-overflow-hidden aok-relative puis-expand-height puis-include-content-margin puis puis-v3a6i3bukpzbs126nsa2nfnnvbe s-latency-cf-section puis-card-border

// //       print('https://www.americanas.com.br/busca/$codigoBarra/');

// //       final res1 = await Dio().get(
// //         // 'https://cors-anywhere.herokuapp.com/' +
// //         'https://www.americanas.com.br/busca/$codigoBarra/',
// //         // 'https://www.amazon.com.br/s?k=7908132275446',
// //         // options: Options(
// //         //   headers: {
// //         //     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
// //         //     'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
// //         //   },
// //         // ),
// //       );
// //       final document1 = parse(res1.data);

//       print('AQUI');

//       // var nome = document1.querySelector('.inStockCard__Link-sc-1ngt5zo-1 .styles__Name-sc-1e4r445-0')?.text;
//       // var preco = document1.querySelector('.inStockCard__Link-sc-1ngt5zo-1 .src__Text-sc-154pg0p-0')?.text;

//       // print('Title: $nome');
//       // print('H1: $preco');

//       return (null, null);
//     } catch (err) {
//       print(err);
//       return (null, errorReturn(err.toString()));
//     }
    try {
      final res = await Dio().get(
        'http://10.1.1.129:8181${ApiRoutes.produtosReadByBarsCode()}',
        options: Options(headers: {'Authorization': _localStorageProvider.getToken()}),
        // options: Options(receiveTimeout: const Duration(seconds: 5), headers: {
        //   ...(_sessionProvider.headers ?? {}),
        //   'codigo_barra': codigoBarra,
        // }),
      );
      // final res = await _apiProvider.dio.get(
      //   ApiRoutes.produtosReadByBarsCode,
      //   options: Options(receiveTimeout: const Duration(seconds: 5), headers: {
      //     ...(_sessionProvider.headers ?? {}),
      //     'codigo_barra': codigoBarra,
      //   }),
      // );

      final ({String nome, String preco}) data = (
        nome: res.data['nome'],
        preco: res.data['preco'].replaceAll('R\$ ', ''),
      );

      return (data, null);
    } on DioException catch (err) {
      return (
        null,
        errorReturn(err.response?.data ?? 'Erro Inesperado'),
      );
    } catch (err) {
      return (null, errorReturn(err.toString()));
    }
  }
}
