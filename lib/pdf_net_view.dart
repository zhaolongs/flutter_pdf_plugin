import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_plugin/pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

class PdfNetScaffold extends StatelessWidget {
  final String pdfUrl;
  final String title;

  PdfNetScaffold({Key? key, required this.pdfUrl, this.title = "详情"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loadingFuture = createFileOfPdfUrl();
    return FutureBuilder<File>(
      //绑定 Future
      future: _loadingFuture,
      //默认显示的占位数据
      initialData: null,
      //需要更新数据对应的Widget
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
            appBar: AppBar(title: Text(title)),
          );
        }
        return PdfScaffold(
          path: snapshot.data!.path,
        );
      },
    );
  }

  Future<File>? _loadingFuture;

  //将PDF下载到本地
  Future<File> createFileOfPdfUrl() async {
    final url = pdfUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
