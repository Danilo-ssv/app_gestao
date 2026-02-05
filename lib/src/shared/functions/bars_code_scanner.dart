import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

Future<String?> barsCodeScanner(BuildContext context) async {
  final res = await SimpleBarcodeScanner.scanBarcode(
    context,
    barcodeAppBar: const BarcodeAppBar(
      appBarTitle: 'Test',
      centerTitle: false,
      enableBackButton: true,
      backButtonIcon: Icon(Icons.arrow_back_ios),
    ),
    isShowFlashIcon: true,
    delayMillis: 500,
    cameraFace: CameraFace.back,
    scanFormat: ScanFormat.ONLY_BARCODE,
  );

  if (!context.mounted) return null;

  if (res == null) {
    showErrorMessage(context, message: 'Erro ao Ler Código de Barra', success: false);
    return null;
  }

  return res;
}
