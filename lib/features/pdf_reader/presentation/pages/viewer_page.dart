import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewerPage extends StatefulWidget {
  final File pdfFile;
  final String pdfName;

  const ViewerPage({super.key, required this.pdfFile, required this.pdfName});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName, style: const TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.5;
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.5;
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        widget.pdfFile,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
