import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../../../core/utils/formatters.dart';
import '../../cubit/recent_pdfs_cubit.dart';
import '../../cubit/recent_pdfs_state.dart';
import '../viewer_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                'Recent Files',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            BlocBuilder<RecentPdfsCubit, RecentPdfsState>(
              builder: (context, state) {
                if (state is RecentPdfsLoading || state is RecentPdfsInitial) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is RecentPdfsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(state.message),
                    ),
                  );
                } else if (state is RecentPdfsLoaded) {
                  if (state.pdfs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No recently opened files.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.pdfs.length,
                    itemBuilder: (context, index) {
                      final pdf = state.pdfs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.history, color: Colors.white),
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
          ],
        ),
      ),
    );
  }
}
