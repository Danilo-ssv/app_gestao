import 'package:app_gestao/src/modules/authentication/models/login_model.dart';
import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/pages/dashboard_page_container.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/authentication/services/authentication_services.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';

class AuthenticationState extends ChangeNotifier {
  final AuthenticationServices _services;
  final LocalStorageProvider _localStorageProvider;

  AuthenticationState(this._services, this._localStorageProvider);

  bool isLoading = false;

  void login(BuildContext context, LoginModel modelo) async {
    isLoading = true;
    notifyListeners();

    final res = await _services.login(modelo);

    if (!context.mounted) return;

    isLoading = false;
    notifyListeners();

    if (res.error?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return;
    }
    if (res.error?.type == TypeErrorModel.notAllowed || res.error?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res.error!.message, success: false);
      return;
    }

    _localStorageProvider.setLocalStorage(SetProps(token: res.token, user: res.user, themeMode: null));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPageContainer()));
  }
}
