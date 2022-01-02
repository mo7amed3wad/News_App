import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/layout/cubit/cubit.dart';
import 'package:news_app/layout/news_layout.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/styles/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'shared/bloc_observer.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');

  runApp(MyApp(
    isDark: isDark,
  ));
}


class MyApp extends StatelessWidget {
  final bool? isDark;

  MyApp({
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NewsCubit()
              ..getBusiness()
              ..getScience()
              ..getSports(),
          ),
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark,
              ),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark!
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: SplashScreenView(
                navigateRoute: NewsLayout(),
                duration: 5000,
                imageSize: 130,
                imageSrc: "assets/images/icon.jpg",
                text: "News App",
                textType: TextType.ColorizeAnimationText,
                textStyle: const TextStyle(
                  fontSize: 40.0,
                ),
                colors: const [
                  Colors.redAccent,
                  Colors.yellow,
                  Colors.red,
                ],
                backgroundColor: AppCubit.get(context).isDark!
                    ? HexColor('333739')
                    : Colors.white,
              ),
            );
          },
        ));
  }
}
