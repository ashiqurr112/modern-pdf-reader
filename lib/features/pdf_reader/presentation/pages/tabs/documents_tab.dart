import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../../../core/utils/formatters.dart';
import '../../cubit/pdf_scanner_cubit.dart';
import '../../cubit/pdf_scanner_state.dart';
import '../../cubit/recent_pdfs_cubit.dart';
import '../viewer_page.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Documents', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search PDFs...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<PdfScannerCubit>().search(value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PdfScannerCubit, PdfScannerState>(
              builder: (context, state) {
                if (state is PdfScannerLoading || state is PdfScannerInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PdfScannerPermissionDenied) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.security, size: 64, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        const Text('Storage permission is required to scan PDFs.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<PdfScannerCubit>().scanFiles(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is PdfScannerError) {
                  return Center(child: Text(state.message));
                } else if (state is PdfScannerLoaded) {
                  if (state.filteredPdfs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No PDFs found.', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.filteredPdfs.length,
                    itemBuilder: (context, index) {
                      final pdf = state.filteredPdfs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.picture_as_pdf, color: Colors.white),
                            ),
                            title: Text(
                              pdf.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${Formatters.formatSize(pdf.size)} • ${pdf.lastModified.toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {
                              context.read<RecentPdfsCubit>().addFileToRecents(pdf.path);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewerPage(pdfFile: File(pdf.path), pdfName: pdf.name),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
