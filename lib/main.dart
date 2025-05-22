import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/theme/app_theme.dart';
import 'package:notebook/theme/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notebook/presentation/screens/home_page.dart';
import 'package:notebook/models/word_pair_wrapper.dart';
import 'package:notebook/state/my_app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordPairWrapperAdapter());

  await Hive.openBox<WordPairWrapper>('favoritesBox');
  await Hive.openBox<WordPairWrapper>('historyBox');

  await ThemeService.init();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // базовий макет (наприклад, iPhone 11)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Namer App',
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            builder: (context, child) {
              // Обгортка для адаптації текстів і елементів
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: child!,
              );
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

