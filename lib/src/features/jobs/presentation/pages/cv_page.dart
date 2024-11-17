import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfModel {
  File? file;
  String? fileName;
  String? url;
  PdfModel({this.file, this.fileName, this.url});
}

class CVPage extends ConsumerWidget {
  final PdfModel pdfModel;
  const CVPage({super.key, required this.pdfModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(pdfModel.fileName.toString()),
      ),
      body: Visibility(
        visible: pdfModel.url != null,
        replacement: PDF(
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
        ).fromPath(pdfModel.file?.path ?? ""),
        child: const PDF().cachedFromUrl(
          pdfModel.url ?? "",
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
