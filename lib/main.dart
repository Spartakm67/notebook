import 'package:english_words/english_words.dart';
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

// class MyAppState extends ChangeNotifier {
//   final favoritesBox = Hive.box<WordPairWrapper>('favoritesBox');
//   final historyBox = Hive.box<WordPairWrapper>('historyBox');
//
//   WordPair current = WordPair.random();
//   bool isDarkMode = ThemeService.getTheme();
//
//   List<WordPair> favorites = [];
//   List<WordPair> history = [];
//
//   GlobalKey<AnimatedListState>? historyListKey;
//
//   MyAppState() {
//     _loadData();
//   }
//
//   void _loadData() {
//     favorites = favoritesBox.values.map((wp) => wp.toWordPair()).toList();
//     history = historyBox.values.map((wp) => wp.toWordPair()).toList();
//   }
//
//   void getNext() {
//     addToHistory(current);
//     current = WordPair.random();
//     notifyListeners();
//   }
//
//   void toggleTheme() {
//     isDarkMode = !isDarkMode;
//     ThemeService.saveTheme(isDarkMode);
//     notifyListeners();
//   }
//
//   void toggleFavorite([WordPair? pair]) {
//     pair = pair ?? current;
//     if (favorites.contains(pair)) {
//       removeFavorite(pair);
//     } else {
//       favorites.add(pair);
//       favoritesBox.add(WordPairWrapper.fromWordPair(pair));
//       notifyListeners();
//     }
//   }
//
//   void removeFavorite(WordPair pair) {
//     favorites.remove(pair);
//
//     final keysToRemove = favoritesBox.keys.where((k) {
//       final saved = favoritesBox.get(k);
//       return saved?.toWordPair() == pair;
//     }).toList();
//
//     for (var key in keysToRemove) {
//       favoritesBox.delete(key);
//     }
//
//     notifyListeners();
//   }
//
//
//   void addToHistory(WordPair pair) {
//     history.insert(0, pair);
//     historyBox.add(WordPairWrapper.fromWordPair(pair));
//     historyListKey?.currentState?.insertItem(0);
//     notifyListeners();
//   }
//
//   void clearHistory() {
//     history.clear();
//     historyBox.clear();
//     notifyListeners();
//   }
// }


