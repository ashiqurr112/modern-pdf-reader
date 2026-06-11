import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/pdf_reader/presentation/cubit/theme_cubit.dart';
import 'features/pdf_reader/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Modern PDF Reader',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
