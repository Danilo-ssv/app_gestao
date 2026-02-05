import 'dart:convert';
import 'dart:developer';

import 'package:app_gestao/src/modules/authentication/models/session_user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { light, dark }

class SetProps {
  final String? token;
  final SessionUserModel? user;
  final ThemeMode? themeMode;

  SetProps({
    required this.token,
    required this.user,
    required this.themeMode,
  });
}

class ClearProps {
  final bool token;
  final bool user;
  final bool themeMode;

  ClearProps({
    required this.token,
    required this.user,
    required this.themeMode,
  });
}

class LocalStorageProvider extends ChangeNotifier {
  bool _isInitialized = false;
  late final SharedPreferences _prefs;

  bool get isInitialized => _isInitialized;

  void init() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      notifyListeners();
    } catch (err) {
      log("Error during Local Storage Init: ${err.toString()}");
    }
  }

  void setLocalStorage(SetProps props) {
    if (!_isInitialized) return;

    if (props.token != null) {
      _prefs.setString('token', props.token!);
    }
    if (props.user != null) {
      _prefs.setString('user', props.user!.toJson());
    }
    if (props.themeMode != null) {
      _prefs.setString('themeMode', props.themeMode!.name);
    }
  }

  void clearLocalStorage(ClearProps props) {
    if (!_isInitialized) return;

    if (props.token) {
      _prefs.remove('token');
    }
    if (props.user) {
      _prefs.remove('user');
    }
    if (props.themeMode) {
      _prefs.remove('themeMode');
    }
  }

  String getToken() {
    if (!_isInitialized) return '';

    try {
      final res = _prefs.getString('token');

      return res ?? '';
    } catch (err) {
      log("Error during Token GET: ${err.toString()}");
      return '';
    }
  }

  SessionUserModel? getUser() {
    if (!_isInitialized) return null;

    try {
      final res = _prefs.getString('user');

      Map<String, dynamic> user = jsonDecode(res!);

      return SessionUserModel(
        id: user['id'],
        idAssinatura: user['idAssinatura'],
        nome: user['nome'],
        email: user['email'],
        root: user['root'],
        adm: user['adm'],
        permissoes: PermissoesUserModel(
          clientesRead: user['permissoes']['clientesRead'],
          clientesInsert: user['permissoes']['clientesInsert'],
          clientesUpdate: user['permissoes']['clientesUpdate'],
          clientesDelete: user['permissoes']['clientesDelete'],
          produtosRead: user['permissoes']['produtosRead'],
          produtosInsert: user['permissoes']['produtosInsert'],
          produtosUpdate: user['permissoes']['produtosUpdate'],
          produtosDelete: user['permissoes']['produtosDelete'],
          produtosInsertBaixaEstoque: user['permissoes']['produtosInsertBaixaEstoque'],
          agendaRead: user['permissoes']['agendaRead'],
          agendaInsert: user['permissoes']['agendaInsert'],
          agendaUpdate: user['permissoes']['agendaUpdate'],
          agendaDelete: user['permissoes']['agendaDelete'],
          usuariosRead: user['permissoes']['usuariosRead'],
          usuariosInsert: user['permissoes']['usuariosInsert'],
          usuariosUpdate: user['permissoes']['usuariosUpdate'],
          usuariosDelete: user['permissoes']['usuariosDelete'],
          fornecedoresRead: user['permissoes']['fornecedoresRead'],
          fornecedoresInsert: user['permissoes']['fornecedoresInsert'],
          fornecedoresUpdate: user['permissoes']['fornecedoresUpdate'],
          fornecedoresDelete: user['permissoes']['fornecedoresDelete'],
          categoriasProdutosRead: user['permissoes']['categoriasProdutosRead'],
          categoriasProdutosInsert: user['permissoes']['categoriasProdutosInsert'],
          categoriasProdutosUpdate: user['permissoes']['categoriasProdutosUpdate'],
          categoriasProdutosDelete: user['permissoes']['categoriasProdutosDelete'],
          despesasRead: user['permissoes']['despesasRead'],
          despesasInsert: user['permissoes']['despesasInsert'],
          despesasUpdate: user['permissoes']['despesasUpdate'],
          despesasDelete: user['permissoes']['despesasDelete'],
          contasPagarRead: user['permissoes']['contasPagarRead'],
          contasPagarInsert: user['permissoes']['contasPagarInsert'],
          contasPagarUpdate: user['permissoes']['contasPagarUpdate'],
          contasPagarDelete: user['permissoes']['contasPagarDelete'],
          contasPagarWriteOff: user['permissoes']['contasPagarWriteOff'],
          contasPagarParcelling: user['permissoes']['contasPagarParcelling'],
          contasReceberRead: user['permissoes']['contasReceberRead'],
          contasReceberInsert: user['permissoes']['contasReceberInsert'],
          contasReceberUpdate: user['permissoes']['contasReceberUpdate'],
          contasReceberDelete: user['permissoes']['contasReceberDelete'],
          contasReceberWriteOff: user['permissoes']['contasReceberWriteOff'],
          contasReceberParcelling: user['permissoes']['contasReceberParcelling'],
          vendasRead: user['permissoes']['vendasRead'],
          vendasInsert: user['permissoes']['vendasInsert'],
          vendasUpdate: user['permissoes']['vendasUpdate'],
          vendasDelete: user['permissoes']['vendasDelete'],
          vendasFinalize: user['permissoes']['vendasFinalize'],
          hfEscolasRead: user['permissoes']['hfEscolasRead'],
          hfEscolasInsert: user['permissoes']['hfEscolasInsert'],
          hfEscolasUpdate: user['permissoes']['hfEscolasUpdate'],
          hfEscolasDelete: user['permissoes']['hfEscolasDelete'],
          hfContratosRead: user['permissoes']['hfContratosRead'],
          hfContratosInsert: user['permissoes']['hfContratosInsert'],
          hfContratosUpdate: user['permissoes']['hfContratosUpdate'],
          hfContratosDelete: user['permissoes']['hfContratosDelete'],
          hfContratosWriteOff: user['permissoes']['hfContratosWriteOff'],
          marcasProdutosRead: user['permissoes']['marcasProdutosRead'],
          marcasProdutosInsert: user['permissoes']['marcasProdutosInsert'],
          marcasProdutosUpdate: user['permissoes']['marcasProdutosUpdate'],
          marcasProdutosDelete: user['permissoes']['marcasProdutosDelete'],
        ),
      );
    } catch (err) {
      log("Error during User GET: ${err.toString()}");
      return null;
    }
  }

  ThemeMode getThemeMode() {
    if (!_isInitialized) return ThemeMode.light;

    try {
      final res = _prefs.getString('themeMode');

      String themeMode = jsonDecode(res ?? '');

      if (themeMode == ThemeMode.dark.name) return ThemeMode.dark;
      return ThemeMode.light;
    } catch (err) {
      log("Error during Theme GET: ${err.toString()}");
      return ThemeMode.light;
    }
  }
}
