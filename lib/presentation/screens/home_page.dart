import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:notebook/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notebook/presentation/widgets/big_card.dart';
import 'package:notebook/presentation/screens/favorites_page.dart';
import 'package:notebook/state/my_app_state.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  final titles = ['Home', 'Favorites', 'Profile', 'Settings'];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[selectedIndex] == 'Home'
              ? '${titles[selectedIndex]} (всього вибрано: ${appState.history.length})'
              : titles[selectedIndex],
          style: AppTextStyles.titleStyle(context),
        ),

        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode_sharp,
              size: 24.sp,
            ),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home, size: 20.sp),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite, size: 20.sp),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    selectedLabelStyle: AppTextStyles.bottomNavSelectedLabelStyle(context),
                    unselectedLabelStyle: AppTextStyles.bottomNavUnselectedLabelStyle(context),
                    selectedIconTheme: AppTextStyles.bottomNavSelectedIconTheme(context),
                    unselectedIconTheme: AppTextStyles.bottomNavUnselectedIconTheme(context),
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home, size: 20.sp),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite, size: 20.sp),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10.h),
          BigCard(pair: pair),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text(
                  'Like',
                  style: AppTextStyles.buttonTextStyle(context),
                ),
              ),
              SizedBox(width: 10.h),
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
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  // final _key = GlobalKey();
  final _key = GlobalKey<AnimatedListState>();


  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            // child: Center(
            //   child: TextButton.icon(
            //     onPressed: () {
            //       appState.toggleFavorite(pair);
            //     },
            //     icon: appState.favorites.contains(pair)
            //         ? Icon(Icons.favorite, size: 12)
            //         : SizedBox(),
            //     label: Text(
            //       pair.asLowerCase,
            //       semanticsLabel: pair.asPascalCase,
            //     ),
            //   ),
            // ),
            child: Dismissible(
              key: ValueKey(pair),
              direction: DismissDirection.horizontal,
              onDismissed: (_) {
                appState.removeFromHistory(pair);
                _key.currentState?.removeItem(
                  index,
                      (context, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: _buildHistoryItem(pair, appState),
                  ),
                );
              },
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: _buildHistoryItem(pair, appState),
            ),

          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(WordPair pair, MyAppState appState) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          appState.toggleFavorite(pair);
        },
        icon: appState.favorites.contains(pair)
            ? Icon(Icons.favorite, size: 12)
            : SizedBox(),
        label: Text(
          pair.asLowerCase,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }

}



