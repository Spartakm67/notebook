import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/theme/app_theme.dart';
import 'package:notebook/theme/theme_service.dart';
import 'package:notebook/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notebook/presentation/widgets/big_card.dart';
import 'package:notebook/main.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('NoteBook App', style: TextStyle(fontSize: 18.sp)),
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 24.sp,
            ),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'A random AWESOME idea:',
              style: AppTextStyles.pureTextStyle(context),
            ),
            SizedBox(height: 10.h),
            BigCard(pair: pair),
            SizedBox(height: 20.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon, size: 16.sp,),
                  label: Text('Like'),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text(
                    'Next',
                    style: AppTextStyles.buttonTextStyle(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}