import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../../core/di/service_locator.dart';
import '../cubit/pdf_scanner_cubit.dart';
import '../cubit/pdf_scanner_state.dart';
import '../cubit/theme_cubit.dart';
import 'viewer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PdfScannerCubit>()..scanFiles(),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final TextEditingController _searchController = TextEditingController();

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Reader', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeCubit.toggleTheme(),
          ),
        ],
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
                              '${_formatSize(pdf.size)} • ${pdf.lastModified.toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {
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
