import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../controllers/controllers.dart';
import '../../shared/shared.dart';

class PDFViewerPage extends StatefulWidget {
  final String? filename;

  const PDFViewerPage({
    super.key,
    this.filename,
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final ThemeController _themeController = Get.find();

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    unbindBackgroundIsolate();
    super.dispose();
  }

  void bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      // final progress = data[2] as int;

      if (status == DownloadTaskStatus.complete) {
        SharedWidget.renderDefaultSnackBar(message: 'Download has finished');
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: _themeController.primaryColor200.value,
        onPressed: () async {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            Directory? directory = Directory('/storage/emulated/0/Download');
            if (!await directory.exists()) {
              directory = await getExternalStorageDirectory();
            }
            debugPrint('Saved: ${directory!.path}');

            FlutterDownloader.enqueue(
              url: Get.arguments,
              savedDir: directory.path,
              showNotification: true,
              fileName:
                  'Dokumen SPK (${DateFormat('EEE, M-d-y HHmm').format(DateTime.now())}).pdf',
              openFileFromNotification: true,
            );
          } else {
            SharedWidget.renderSettingsBottomModal(
                subtitle: 'This app requires storage access');
          }
        },
        child: const Icon(EvaIcons.downloadOutline),
      ),
      body: SfPdfViewer.network(Get.arguments),
    );
  }
}
