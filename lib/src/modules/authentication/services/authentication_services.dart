import 'package:app_gestao/src/modules/authentication/models/login_model.dart';
import 'package:app_gestao/src/modules/authentication/models/session_user_model.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';

class AuthenticationServices {
  final LocalStorageProvider _localStorageProvider;
  final ApiProvider _apiProvider;

  AuthenticationServices(this._localStorageProvider, this._apiProvider);

  Future<({SessionUserModel? user, String? token, ErrorModel? error})> login(LoginModel modelo) async {
    try {
      final res = await _apiProvider.dio.post(ApiRoutes.login(), data: {
        ...modelo.toMap(),
      });

      final String token = res.data['token'];
      final SessionUserModel user = SessionUserModel(
        id: res.data['user']['id'],
        idAssinatura: res.data['user']['idAssinatura'],
        nome: res.data['user']['nome'],
        email: res.data['user']['email'],
        root: res.data['user']['root'],
        adm: res.data['user']['adm'],
        permissoes: PermissoesUserModel(
          clientesRead: res.data['user']['permissoes']['clientesRead'],
          clientesInsert: res.data['user']['permissoes']['clientesInsert'],
          clientesUpdate: res.data['user']['permissoes']['clientesUpdate'],
          clientesDelete: res.data['user']['permissoes']['clientesDelete'],
          produtosRead: res.data['user']['permissoes']['produtosRead'],
          produtosInsert: res.data['user']['permissoes']['produtosInsert'],
          produtosUpdate: res.data['user']['permissoes']['produtosUpdate'],
          produtosDelete: res.data['user']['permissoes']['produtosDelete'],
          produtosInsertBaixaEstoque: res.data['user']['permissoes']['produtosInsertBaixaEstoque'],
          agendaRead: res.data['user']['permissoes']['agendaRead'],
          agendaInsert: res.data['user']['permissoes']['agendaInsert'],
          agendaUpdate: res.data['user']['permissoes']['agendaUpdate'],
          agendaDelete: res.data['user']['permissoes']['agendaDelete'],
          usuariosRead: res.data['user']['permissoes']['usuariosRead'],
          usuariosInsert: res.data['user']['permissoes']['usuariosInsert'],
          usuariosUpdate: res.data['user']['permissoes']['usuariosUpdate'],
          usuariosDelete: res.data['user']['permissoes']['usuariosDelete'],
          fornecedoresRead: res.data['user']['permissoes']['fornecedoresRead'],
          fornecedoresInsert: res.data['user']['permissoes']['fornecedoresInsert'],
          fornecedoresUpdate: res.data['user']['permissoes']['fornecedoresUpdate'],
          fornecedoresDelete: res.data['user']['permissoes']['fornecedoresDelete'],
          categoriasProdutosRead: res.data['user']['permissoes']['categoriasProdutosRead'],
          categoriasProdutosInsert: res.data['user']['permissoes']['categoriasProdutosInsert'],
          categoriasProdutosUpdate: res.data['user']['permissoes']['categoriasProdutosUpdate'],
          categoriasProdutosDelete: res.data['user']['permissoes']['categoriasProdutosDelete'],
          despesasRead: res.data['user']['permissoes']['despesasRead'],
          despesasInsert: res.data['user']['permissoes']['despesasInsert'],
          despesasUpdate: res.data['user']['permissoes']['despesasUpdate'],
          despesasDelete: res.data['user']['permissoes']['despesasDelete'],
          contasPagarRead: res.data['user']['permissoes']['contasPagarRead'],
          contasPagarInsert: res.data['user']['permissoes']['contasPagarInsert'],
          contasPagarUpdate: res.data['user']['permissoes']['contasPagarUpdate'],
          contasPagarDelete: res.data['user']['permissoes']['contasPagarDelete'],
          contasPagarWriteOff: res.data['user']['permissoes']['contasPagarWriteOff'],
          contasPagarParcelling: res.data['user']['permissoes']['contasPagarParcelling'],
          contasReceberRead: res.data['user']['permissoes']['contasReceberRead'],
          contasReceberInsert: res.data['user']['permissoes']['contasReceberInsert'],
          contasReceberUpdate: res.data['user']['permissoes']['contasReceberUpdate'],
          contasReceberDelete: res.data['user']['permissoes']['contasReceberDelete'],
          contasReceberWriteOff: res.data['user']['permissoes']['contasReceberWriteOff'],
          contasReceberParcelling: res.data['user']['permissoes']['contasReceberParcelling'],
          vendasRead: res.data['user']['permissoes']['vendasRead'],
          vendasInsert: res.data['user']['permissoes']['vendasInsert'],
          vendasUpdate: res.data['user']['permissoes']['vendasUpdate'],
          vendasDelete: res.data['user']['permissoes']['vendasDelete'],
          vendasFinalize: res.data['user']['permissoes']['vendasFinalize'],
          hfEscolasRead: res.data['user']['permissoes']['hfEscolasRead'],
          hfEscolasInsert: res.data['user']['permissoes']['hfEscolasInsert'],
          hfEscolasUpdate: res.data['user']['permissoes']['hfEscolasUpdate'],
          hfEscolasDelete: res.data['user']['permissoes']['hfEscolasDelete'],
          hfContratosRead: res.data['user']['permissoes']['hfContratosRead'],
          hfContratosInsert: res.data['user']['permissoes']['hfContratosInsert'],
          hfContratosUpdate: res.data['user']['permissoes']['hfContratosUpdate'],
          hfContratosDelete: res.data['user']['permissoes']['hfContratosDelete'],
          hfContratosWriteOff: res.data['user']['permissoes']['hfContratosWriteOff'],
          marcasProdutosRead: res.data['user']['permissoes']['marcasProdutosRead'],
          marcasProdutosInsert: res.data['user']['permissoes']['marcasProdutosInsert'],
          marcasProdutosUpdate: res.data['user']['permissoes']['marcasProdutosUpdate'],
          marcasProdutosDelete: res.data['user']['permissoes']['marcasProdutosDelete'],
        ),
      );

      return (user: user, token: token, error: null);

      // String? rawCookie = res.headers.map['set-cookie']?.first;
      // if (rawCookie == null) return (null, null);
      // int index = rawCookie.indexOf(';');

      // return (
      //   {
      //     'Cookie': (index == -1) ? rawCookie : rawCookie.substring(0, index),
      //   },
      //   null,
      // );
    } on DioException catch (err) {
      return (user: null, token: null, error: errorReturn(err.response?.data ?? 'Erro Inesperado'));
    } catch (err) {
      return (user: null, token: null, error: errorReturn(err.toString()));
    }
  }

  Future<ErrorModel?> logout() async {
    try {
      await _apiProvider.dio.post(
        ApiRoutes.logout(),
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
