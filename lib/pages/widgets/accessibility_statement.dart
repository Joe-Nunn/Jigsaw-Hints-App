import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessibilityStatementPage extends StatefulWidget {
  const AccessibilityStatementPage({super.key});

  @override
  State<AccessibilityStatementPage> createState() =>
      _AccessibilityStatementPageState();
}

class _AccessibilityStatementPageState
    extends State<AccessibilityStatementPage> {
  String pdfUrl = "";
  bool isLoading = true;
  int pages = 0;
  int currentPage = 0;
  PDFViewController? pdfViewController;
  late Future<File> pdfFileFuture;

  @override
  void initState() {
    ensureHasStoragePermission();
    pdfFileFuture = fromAsset(
        'assets/accessibility_statement.pdf', 'accessibility_statement.pdf');
    super.initState();
  }

  Future<File> fromAsset(String asset, String filename) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
  }

  Future<void> ensureHasStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const JigsawAppBar(
        title: "Statement",
      ),
      body: FutureBuilder(
          future: pdfFileFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pdfUrl = snapshot.data!.path;
              return Stack(
                children: [
                  PDFView(
                    filePath: pdfUrl,
                    autoSpacing: true,
                    pageFling: true,
                    onRender: (pages) {
                      setState(() {
                        isLoading = false;
                        this.pages = pages!;
                      });
                    },
                    onError: (error) {
                      debugPrint(error.toString());
                    },
                    onPageChanged: (int? page, int? total) {
                      if (page != null) {
                        setState(() {
                          currentPage = page;
                        });
                      }
                    },
                    onViewCreated: (PDFViewController viewController) {
                      setState(() {
                        pdfViewController = viewController;
                      });
                    },
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (currentPage > 0) {
                  pdfViewController?.setPage(currentPage - 1);
                }
              },
            ),
            Text("${currentPage + 1} / $pages"),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                if (currentPage < pages - 1) {
                  pdfViewController?.setPage(currentPage + 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
