import 'package:flutter/material.dart';
import 'package:notebook/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notebook/state/my_app_state.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet.',
          style: AppTextStyles.titleStyle(context),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        final header = Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            'You have ${appState.favorites.length} favorites:',
            style: AppTextStyles.titleStyle(context),
          ),
        );

        if (!isWide) {
          // Вертикальний список для мобільних
          return ListView(
            children: [
              header,
              ...appState.favorites.map((pair) {
                return ListTile(
                  leading: Icon(Icons.favorite, size: 20.sp),
                  title: Text(
                    pair.asLowerCase,
                    style: AppTextStyles.pureTextStyle(context),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, size: 20.sp),
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                );
              }),
            ],
          );
        } else {
          // Адаптивна сітка для широких екранів
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              Expanded(
                child: GridView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400.w,
                    childAspectRatio: 400 / 80,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                  ),
                  children: appState.favorites.map((pair) {
                    return ListTile(
                      leading: Icon(Icons.favorite, size: 20.sp),
                      title: Text(
                        pair.asLowerCase,
                        style: AppTextStyles.pureTextStyle(context),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, size: 20.sp),
                        onPressed: () {
                          appState.removeFavorite(pair);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

