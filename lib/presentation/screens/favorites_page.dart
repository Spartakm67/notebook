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

// ...

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.', style:  AppTextStyles.titleStyle(context),),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:', style: AppTextStyles.titleStyle(context),),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite, size: 20.sp,),
            title: Text(pair.asLowerCase, style: AppTextStyles.pureTextStyle(context),),
          ),
      ],
    );
  }
}