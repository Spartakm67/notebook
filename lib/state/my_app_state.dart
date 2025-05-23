import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notebook/models/word_pair_wrapper.dart';
import 'package:notebook/theme/theme_service.dart';

class MyAppState extends ChangeNotifier {
  final favoritesBox = Hive.box<WordPairWrapper>('favoritesBox');
  final historyBox = Hive.box<WordPairWrapper>('historyBox');

  WordPair current = WordPair.random();
  bool isDarkMode = ThemeService.getTheme();

  List<WordPair> favorites = [];
  List<WordPair> history = [];

  GlobalKey<AnimatedListState>? historyListKey;

  MyAppState() {
    _loadData();
  }

  void _loadData() {
    favorites = favoritesBox.values.map((wp) => wp.toWordPair()).toList();
    history = historyBox.values.map((wp) => wp.toWordPair()).toList();
  }

  void getNext() {
    addToHistory(current);
    current = WordPair.random();
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    ThemeService.saveTheme(isDarkMode);
    notifyListeners();
  }

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      removeFavorite(pair);
    } else {
      favorites.add(pair);
      favoritesBox.add(WordPairWrapper.fromWordPair(pair));
      notifyListeners();
    }
  }

  // void removeFavorite(WordPair pair) {
  //   favorites.remove(pair);
  //
  //   final keysToRemove = favoritesBox.keys.where((k) {
  //     final saved = favoritesBox.get(k);
  //     return saved?.toWordPair() == pair;
  //   }).toList();
  //
  //   for (var key in keysToRemove) {
  //     favoritesBox.delete(key);
  //   }
  //
  //   notifyListeners();
  // }

  void removeFavorite(WordPair pair, {bool notify = true}) {
    favorites.removeWhere((p) => p == pair);

    final keysToRemove = favoritesBox.keys.where((k) {
      final saved = favoritesBox.get(k);
      return saved?.toWordPair() == pair;
    }).toList();

    for (var key in keysToRemove) {
      favoritesBox.delete(key);
    }

    // Також видаляємо з history
    history.removeWhere((p) => p == pair);

    final historyKeysToRemove = historyBox.keys.where((k) {
      final saved = historyBox.get(k);
      return saved?.toWordPair() == pair;
    }).toList();

    for (var key in historyKeysToRemove) {
      historyBox.delete(key);
    }

    if (notify) {
      notifyListeners();
    }
  }



  void addToHistory(WordPair pair) {
    history.insert(0, pair);
    historyBox.add(WordPairWrapper.fromWordPair(pair));
    historyListKey?.currentState?.insertItem(0);
    notifyListeners();
  }

  // void removeFromHistory(WordPair pair) {
  //   history.remove(pair);
  //
  //   // Видалити з Hive (знаходимо всі ключі, де значення дорівнює цій парі)
  //   final keysToRemove = historyBox.keys.where((key) {
  //     final saved = historyBox.get(key);
  //     return saved?.toWordPair() == pair;
  //   }).toList();
  //
  //   for (var key in keysToRemove) {
  //     historyBox.delete(key);
  //   }
  //
  //   notifyListeners();
  // }

  void removeFromHistory(WordPair pair) {
    // Видалення з history
    history.removeWhere((p) => p == pair);

    // Видалення з Hive
    final historyKeysToRemove = historyBox.keys.where((key) {
      final saved = historyBox.get(key);
      return saved?.toWordPair() == pair;
    }).toList();
    for (var key in historyKeysToRemove) {
      historyBox.delete(key);
    }

    // Також видаляємо з favorites, якщо є
    removeFavorite(pair, notify: false); // нижче буде пояснення про notify

    notifyListeners();
  }


  void clearHistory() {
    history.clear();
    historyBox.clear();
    notifyListeners();
  }
}
