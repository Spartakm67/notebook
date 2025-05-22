import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:notebook/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.tertiary,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: AppTextStyles.bigCardTextStyle(context),
                ),
                SizedBox(width: 8.w),
                Text(
                  pair.second,
                  style: AppTextStyles.bigCardTextStyle(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
