import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdfrx/pdfrx.dart';

class ViewerPage extends StatefulWidget {
  final File pdfFile;
  final String pdfName;

  const ViewerPage({super.key, required this.pdfFile, required this.pdfName});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  bool _isInit = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late final PdfTextSearcher _textSearcher;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _textSearcher = PdfTextSearcher(_pdfViewerController)..addListener(_update);
    
    // Delay initialization to allow page route animation to finish smoothly
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isInit = true;
        });
      }
    });
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textSearcher.removeListener(_update);
    _textSearcher.dispose();
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
                    _textSearcher.startTextSearch(value, caseInsensitive: true);
                  }
                },
              )
            : Text(widget.pdfName, style: const TextStyle(fontSize: 16)),
        actions: [
          if (_isSearching) ...[
            if (_textSearcher.hasMatches)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${(_textSearcher.currentIndex ?? 0) + 1}/${_textSearcher.matches.length}',
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: _textSearcher.hasMatches ? () => _textSearcher.goToPrevMatch() : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: _textSearcher.hasMatches ? () => _textSearcher.goToNextMatch() : null,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _textSearcher.resetTextSearch();
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
          ],
        ],
      ),
      body: !_isInit
          ? const Center(child: CircularProgressIndicator())
          : PdfViewer.file(
              widget.pdfFile.path,
              controller: _pdfViewerController,
              params: PdfViewerParams(
                pagePaintCallbacks: [
                  _textSearcher.pageTextMatchPaintCallback
                ],
              ),
            ),
    );
  }
}
