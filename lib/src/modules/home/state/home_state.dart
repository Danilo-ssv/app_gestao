import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/home/services/home_services.dart';
import 'package:app_gestao/src/shared/functions/error_return.dart';

class HomeState extends ChangeNotifier {
  final HomeServices _services;

  HomeState(this._services);

  void home(BuildContext context) async {
    final res = await _services.home();

    if (!context.mounted) return;

    if (res?.type == TypeErrorModel.notAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return;
    }
    if (res?.type == TypeErrorModel.notAllowed || res?.type == TypeErrorModel.common) {
      showErrorMessage(context, message: res!.message, success: false);
      return;
    }
  }
}
