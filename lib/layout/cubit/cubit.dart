import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/states.dart';
import 'package:news_app/modules/business/business.dart';
import 'package:news_app/modules/science/science.dart';
import 'package:news_app/modules/sports/sports.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> listScreens = [
    BusinessScreen(),
    SportsScreen(),
    SciencesScreen(),
  ];

  List<BottomNavigationBarItem> bottomItem =
  [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(
        icon: Icon(Icons.sports_esports_outlined), label: 'Sports'),
    BottomNavigationBarItem(
        icon: Icon(Icons.science_outlined), label: 'Science'),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'eg',
        'category':'business',
        'apiKey': 'c5aab65681ec4d7d860ab489980b32de'
      },
    ).then((value) {
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports()
  {
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'sports',
          'apiKey':'c5aab65681ec4d7d860ab489980b32de',
        },
      ).then((value)
      {
        //print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else
    {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience()
  {
    emit(NewsGetScienceLoadingState());

    if(science.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'science',
          'apiKey':'c5aab65681ec4d7d860ab489980b32de',
        },
      ).then((value)
      {
        //print(value.data['articles'][0]['title']);
        science = value.data['articles'];
        print(science[0]['title']);

        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else
    {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query:
      {
        'q':'$value',
        'apiKey':'c5aab65681ec4d7d860ab489980b32de',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}
