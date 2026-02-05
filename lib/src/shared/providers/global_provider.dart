import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/models/global_hf_escolas_model.dart';
import 'package:app_gestao/src/shared/models/global_marcas_produtos_model.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/models/global_Fornecedores_model.dart';
import 'package:app_gestao/src/shared/models/global_categorias_produtos_model.dart';
import 'package:app_gestao/src/shared/models/global_clientes_model.dart';
import 'package:app_gestao/src/shared/models/global_despesas_model.dart';
import 'package:app_gestao/src/shared/models/global_municipios_model.dart';
import 'package:app_gestao/src/shared/providers/global_services.dart';

class GlobalProvider {
  final GlobalServices _services;
  GlobalProvider(this._services);

  Future<List<GlobalMunicipiosModel>?> readMunicipios(BuildContext context, String search, String uf) async {
    final res = await _services.readMunicipios(search, uf);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalFornecedoresModel>?> readFornecedores(BuildContext context, String search) async {
    final res = await _services.readFornecedores(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalCategoriasProdutosModel>?> readCategoriasProdutos(BuildContext context, String search) async {
    final res = await _services.readCategoriasProdutos(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalDespesasModel>?> readDespesas(BuildContext context, String search) async {
    final res = await _services.readDespesas(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalClientesModel>?> readClientes(BuildContext context, String search) async {
    final res = await _services.readClientes(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalHfEscolasModel>?> readHfEscolas(BuildContext context, String search) async {
    final res = await _services.readHfEscolas(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<List<GlobalMarcasProdutosModel>?> readMarcasProdutos(BuildContext context, String search) async {
    final res = await _services.readMarcasProdutos(search);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.data;
  }

  Future<String?> insertFornecedores(BuildContext context, String nome) async {
    final res = await _services.insertFornecedores(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }

  Future<String?> insertCategoriasProdutos(BuildContext context, String nome) async {
    final res = await _services.insertCategoriasProdutos(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }

  Future<String?> insertDespesas(BuildContext context, String nome) async {
    final res = await _services.insertDespesas(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }

  Future<String?> insertClientes(BuildContext context, String nome) async {
    final res = await _services.insertClientes(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }

    Future<String?> insertHfEscolas(BuildContext context, String nome) async {
    final res = await _services.insertHfEscolas(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }

    Future<String?> insertMarcasProdutos(BuildContext context, String nome) async {
    final res = await _services.insertMarcasProdutos(nome);

    if (!context.mounted) return null;

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return null;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return null;
    }

    return res.id;
  }
}
