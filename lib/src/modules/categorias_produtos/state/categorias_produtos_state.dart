import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/categorias_produtos/models/categorias_produtos_model.dart';
import 'package:app_gestao/src/modules/categorias_produtos/models/insert_categorias_produtos_model.dart';
import 'package:app_gestao/src/modules/categorias_produtos/services/categorias_produtos_services.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';

enum Loading {
  refresh,
  loadMore,
  loadInsertPage,
  insert,
  none,
}

class CategoriasProdutosState extends ChangeNotifier {
  final CategoriasProdutosServices _services;
  CategoriasProdutosState(this._services);

  List<CategoriasProdutosModel> data = [];
  List<String> selectedItems = [];
  Loading loading = Loading.none;
  String search = '';
  int numberOfPages = 1;
  int page = 1;
  int limit = 20;

  Future<void> read(BuildContext context, {required bool loadMore}) async {
    loading = loadMore ? Loading.loadMore : Loading.refresh;
    notifyListeners();

    final res = await _services.read(search, page, limit);

    if (!context.mounted) return;

    loading = Loading.none;
    notifyListeners();

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return;
    }

    numberOfPages = res.numberOfPages ?? 1;
    data = loadMore ? [...data, ...(res.data ?? [])] : (res.data ?? []);
    notifyListeners();
  }

  Future<bool> insert(BuildContext context, InsertCategoriasProdutosModel modelo) async {
    loading = Loading.insert;
    notifyListeners();

    final res = await _services.insert(modelo);

    if (!context.mounted) return false;

    loading = Loading.none;
    notifyListeners();

    if (res?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return false;
    }
    if (res?.type == TypeErrorModel.notAllowed || res?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res!.message, success: false);
      return false;
    }

    Navigator.pop(context);
    return true;
  }

  Future<bool> delete(BuildContext context, List<String> listaIds) async {
    final res = await _services.delete(listaIds);

    if (!context.mounted) return false;

    if (res?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return false;
    }
    if (res?.type == TypeErrorModel.notAllowed || res?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res!.message, success: false);
      return false;
    }

    selectedItems = [];
    page = 1;
    read(context, loadMore: false);
    return true;
  }

  Future<InsertCategoriasProdutosModel?> readById(BuildContext context, String id) async {
    loading = Loading.loadInsertPage;
    notifyListeners();

    final res = await _services.readById(id);

    if (!context.mounted) return null;

    loading = Loading.none;
    notifyListeners();

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

  void changeSearch(String value) {
    selectedItems = [];
    search = value;
    numberOfPages = 1;
    page = 1;
  }

  void changePage({required bool increment}) {
    if (increment) {
      if (page >= numberOfPages) return;

      page++;
      selectedItems = [];
      notifyListeners();
      return;
    }

    if (page <= 1) return;

    page--;
    selectedItems = [];
    notifyListeners();
  }

  void changeSelectedItems(String id, {bool selectAll = false}) {
    if (selectAll) {
      if (selectedItems.length == data.length) {
        selectedItems.clear();
      } else {
        selectedItems = [...data.map((e) => e.id)];
      }
      notifyListeners();
      return;
    }

    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
    notifyListeners();
  }

  void resetOnDispose() {
    data = [];
    selectedItems = [];
    search = '';
    numberOfPages = 1;
    page = 1;
  }
}
