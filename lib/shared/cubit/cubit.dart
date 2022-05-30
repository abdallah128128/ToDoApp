import 'package:bloc/bloc.dart';
import 'package:bode_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:bode_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:bode_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:bode_flutter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  //--------------------------------------------------------------------------------------
  int currentIndex = 0;

  void changeBottomIndex(int index) {
    currentIndex = index;
    emit(changeBottomNavItem());
  }

  //--------------------------------------------------------------------------------------
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  //Create
  void createDataBase() {
    openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
          'CREATE TABLE TASKS (id INTEGER PRIMARY KEY , title TEXT , data TEXT , time TEXT , status TEXT)',
        )
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print(error.toString());
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print('DataBase Opend');
      },
    ).then((value) {
      database = value;
      print(database);
      emit(createDatabaseState());
    });
  }

  //--------------------------------------------------------------------------------------
  //Insert
  Future insertToDataBase({
    required String title,
    required String date,
    required String time,
  }) {
    return database!.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO TASKS(title,data,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('Insert Succesefully');
        emit(insertToDatabaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  //--------------------------------------------------------------------------------------
  //Get
  void getDataFromDataBase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(getFromDatabaseLoadingState());
    database.rawQuery('select * from Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'Done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(getFromDatabaseState());
    });
  }

  //--------------------------------------------------------------------------------------
  //Update
  void UpdateDataBase({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDataBase(database);
      emit(updateDatabaseState());
    });
  }

//--------------------------------------------------------------------------------------
  void deleteData({
    required int id,
  }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(deleteFromDatabaseState());
    });
  }

  //--------------------------------------------------------------------------------------
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(changeBottomSheetState());
  }
}
