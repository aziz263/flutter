import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class Scanner {
  final QrBarCodeScannerDialog _qrBarCodeScannerDialogPlugin;

  Scanner() : _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    
  void qrCode(BuildContext context, Function(String?) onCode) {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: context,
      onCode: onCode,
    );
  }
}
