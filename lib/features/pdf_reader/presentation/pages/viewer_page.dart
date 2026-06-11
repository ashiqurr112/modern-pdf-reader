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
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchResult = _pdfViewerController.searchText(value);
                    setState(() {});
                  }
                },
              )
            : Text(widget.pdfName, style: const TextStyle(fontSize: 16)),
        actions: [
          if (_isSearching) ...[
            if (_searchResult.hasResult)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: _searchResult.hasResult ? () {
                _searchResult.previousInstance();
                setState(() {});
              } : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: _searchResult.hasResult ? () {
                _searchResult.nextInstance();
                setState(() {});
              } : null,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchResult.clear();
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
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
                final newZoom = _pdfViewerController.zoomLevel - 0.5;
                _pdfViewerController.zoomLevel = newZoom < 1.0 ? 1.0 : newZoom;
              },
            ),
          ],
        ],
      ),
      body: SfPdfViewer.file(
        widget.pdfFile,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
      ),
    );
  }
}
