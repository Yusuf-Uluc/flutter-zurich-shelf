import 'dart:io' show Platform;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

import '../models/qr_session_model.dart';
import '../services.dart';

class ScannerBottomSheet extends StatefulWidget {
  const ScannerBottomSheet({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;

  @override
  State<ScannerBottomSheet> createState() => ScannerBottomSheetState();
}

class ScannerBottomSheetState extends State<ScannerBottomSheet> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(() {
          result = scanData;
        });
        if (result != null) {
          Services.authenticateQRSession(QRSession(
            id: result!.code!,
            email: widget.email,
            password: widget.password,
          ));
          Navigator.popUntil(context, ModalRoute.withName('Home'));
        }
      },
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    setState(() {
      result = null;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      overlay: QrScannerOverlayShape(borderWidth: 10),
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }
}
