import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/contas_receber/models/contas_receber_model.dart';
import 'package:app_gestao/src/modules/contas_receber/models/insert_contas_receber_model.dart';
import 'package:app_gestao/src/modules/contas_receber/services/contas_receber_services.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:intl/intl.dart';

enum Status { $0, $1, $2, $3 }

extension StatusExtension on Status {
  String format() => name.split("").last;
}

enum Loading {
  refresh,
  loadMore,
  loadInsertPage,
  insert,
  none,
}

class ContasReceberState extends ChangeNotifier {
  final ContasReceberServices _services;
  ContasReceberState(this._services);

  List<ContasReceberModel> data = [];
  List<String> selectedItems = [];
  Loading loading = Loading.none;
  DateTimeRange? dateTimeRange;
  Status status = Status.$1;
  String search = '';
  int numberOfPages = 1;
  int page = 1;
  int limit = 20;

  Future<void> read(BuildContext context, {required bool loadMore}) async {
    loading = loadMore ? Loading.loadMore : Loading.refresh;
    notifyListeners();

    final startDate = DateFormat('yyyy-MM-dd').format(dateTimeRange!.start);
    final endDate = DateFormat('yyyy-MM-dd').format(dateTimeRange!.end);

    final res = await _services.read(search, page, limit, startDate, endDate, status.format());

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

  Future<bool> insert(BuildContext context, InsertContasReceberModel modelo) async {
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

  Future<InsertContasReceberModel?> readById(BuildContext context, String id) async {
    loading = Loading.loadInsertPage;
    // notifyListeners();

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

  Future<bool> writeOff(BuildContext context, String id, String dataBaixa, String desconto) async {
    final res = await _services.writeOff(id, dataBaixa, desconto);

    if (!context.mounted) return false;

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

  Future<bool> parcelling(BuildContext context, String id, int parcelas, int frequencia) async {
    final res = await _services.parcelling(id, parcelas, frequencia);

    if (!context.mounted) return false;

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

  void changeSearch(String value) {
    selectedItems = [];
    search = value;
    numberOfPages = 1;
    page = 1;
  }

  void changeDateTimeRange(DateTimeRange date) {
    selectedItems = [];
    dateTimeRange = date;
    numberOfPages = 1;
    page = 1;
  }

  void changeStatus(Status value) {
    selectedItems = [];
    status = value;
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

  void resetOnDispose({bool resetFilters = true}) {
    data = [];
    selectedItems = [];
    if (resetFilters) {
      dateTimeRange = null;
      status = Status.$1;
    }
    search = '';
    numberOfPages = 1;
    page = 1;
  }
}
