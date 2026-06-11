import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewerPage extends StatefulWidget {
  final File pdfFile;
  final String pdfName;

  const ViewerPage({super.key, required this.pdfFile, required this.pdfName});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName, style: const TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.pdfFile.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (renderPages) {
              setState(() {
                pages = renderPages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink()
              : Center(child: Text(errorMessage)),
        ],
      ),
      floatingActionButton: isReady 
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: Text('${(currentPage ?? 0) + 1} / $pages'),
            )
          : null,
    );
  }
}
