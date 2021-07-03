import 'dart:async';
import 'dart:io';
import 'package:kindergaten/Model/playModel.dart';
import 'package:kindergaten/Model/taketestModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
class DataBaseOpener with ChangeNotifier{

  static const _dbName = 'myDatabase.db';
  static const _version = 1;
  static const _bookmarktable  = "bookmark";
  static const _recentlyWatched  = "recentwatch";
  static final _columId = '_id';
  static final columequestion = 'questions';
  static final columechA= 'chA';
  static final columechB = 'chB';
  static final columechC = 'chC';
  static final columechD = 'chD';
  static final columehint = 'hint';
  static final columeAnswer = 'answer';
  static final columeSelected = 'selected';

  static final theme = 'theme';
  static final videoTitle = 'videoTitle';
  static final videoSource = 'videoSource';
  static final videoName = 'videoName';
  static final videoAbout = 'videoAbout';
  static final videoNote = 'videoNote';
  static final percentage = 'percentage';

  DataBaseOpener._privateConstructor();

  static final DataBaseOpener instance = DataBaseOpener._privateConstructor();

  static Database _database;

  Future<Database> get database async{

    if(_database != null) return _database;

    _database = await _initializedDatabase();
    return _database;

  }

  _initializedDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _version, onCreate: _onCreate);

  }
  Future _onCreate(Database db, int version){

    db.execute(
        '''
        CREATE TABLE IF NOT EXISTS $_bookmarktable (
       $_columId INTEGER PRIMARY KEY,
       $theme TEXT NOT NULL,
       $videoTitle TEXT,
       $videoSource TEXT,
       $videoName TEXT,
       $videoAbout TEXT,
       $videoNote TEXT,
       $percentage INTEGER
       )

       '''
    );

  }

  // Future<void> insertbookmark(Map<String, dynamic> row) async{
  //   Database db = await instance.database;
  //
  //   List<Map> maps = await db.query(_bookmarktable,
  //       columns: [_columId, theme, videoTitle, videoSource, videoName, videoAbout, videoNote],
  //       where: '$videoName = ?',
  //       whereArgs: [row['videoName']]);
  //
  //
  //   if(maps.isEmpty){
  //
  //     await db.insert(_recentlyWatched, row);
  //     notifyListeners();
  //   }
  //
  // }

  Future<void> insertrecently(Map<String, dynamic> row) async{
    Database db = await instance.database;
    await   db.execute(
        '''
        CREATE TABLE IF NOT EXISTS $_recentlyWatched (
       $_columId INTEGER PRIMARY KEY,
       $theme TEXT NOT NULL,
       $videoTitle TEXT,
       $videoSource TEXT,
       $videoName TEXT,
       $videoAbout TEXT,
       $videoNote TEXT,
       $percentage INTEGER
       )
       '''
    );
    List<Map> maps = await db.query(_recentlyWatched,
        columns: [_columId, theme, videoTitle, videoSource, videoName, videoAbout, videoNote],
        where: '$videoName = ?',
        whereArgs: [row['videoName']]);


    if(maps.isEmpty){

      await db.insert(_recentlyWatched, row);
      notifyListeners();
    }


  }

  Future<void> inserttest(List<TakeTestProvider> questions, Map<int, String> options,var paper) async {
    //   Map<String, dynamic> row

    Database db = await instance.database;
    await db.execute("DROP TABLE IF EXISTS $paper");
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $paper(
       $_columId INTEGER PRIMARY KEY,
       $columequestion TEXT NOT NULL,
       $columechA TEXT,
       $columechB TEXT,
       $columechC TEXT,
       $columechD TEXT,
       $columehint TEXT,
       $columeAnswer TEXT,
       $columeSelected TEXT

    )
    '''
    );
    try{
      for(int i = 0; i < questions.length;i++) {
        Map<String, dynamic> row = {
          DataBaseOpener.columequestion: '${questions[i].question}',
          DataBaseOpener.columechA: '${questions[i].chA}',
          DataBaseOpener.columechB: '${questions[i].chB}',
          DataBaseOpener.columechC: '${questions[i].chC}',
          DataBaseOpener.columechD: '${questions[i].chD}',
          DataBaseOpener.columeAnswer: '${questions[i].choice}',
          DataBaseOpener.columeSelected: '${options[i]}'
        };
        db.insert(paper, row);

      }
      notifyListeners();
    }catch(e){
      print(e.toString());
    }

//    return 1;
    // var result = await db.rawQuery('SELECT * FROM $paper WHERE $columequestion = "${row['questions']}"');
    //
    // if(result.isEmpty){
    //   return await db.insert(paper, row);
    // }

  }


  Future<List<TakeTestProvider>> queryAllTest( var paper) async{
    Database db = await instance.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $paper(
       $_columId INTEGER PRIMARY KEY,
       $columequestion TEXT NOT NULL,
       $columechA TEXT,
       $columechB TEXT,
       $columechC TEXT,
       $columechD TEXT,
       $columeAnswer TEXT,
       $columeSelected TEXT

    )
    '''
    );




    final List<Map<String, dynamic>> maps = await db.query(paper);
    return List.generate(maps.length, (i) {
      return TakeTestProvider(
        question: maps[i]['$columequestion'],
        chA: maps[i]['$columechA'],
        chB: maps[i]['$columechB'],
        chC: maps[i]['$columechC'],
        chD: maps[i]['$columechD'],
        choice: maps[i]['$columeAnswer'],
        hint: maps[i]['$columehint'],
        selected: maps[i]['$columeSelected'],
      );
    });

  }
  Future<List<VideosModelProvider>> queryAllBookmarks() async{
    //  screenwidth =width;
    Database db = await instance.database;
    await db.execute(
        '''
        CREATE TABLE IF NOT EXISTS $_bookmarktable (
       $_columId INTEGER PRIMARY KEY,
       $theme TEXT NOT NULL,
       $videoTitle TEXT,
       $videoSource TEXT,
       $videoName TEXT,
       $videoAbout TEXT,
       $videoNote TEXT,
       $percentage INTEGER
       )

       '''
    );


    final List<Map<String, dynamic>> maps = await db.query(_bookmarktable);
    return List.generate(maps.length, (i) {
      return VideosModelProvider(
          theme: maps[i]['$theme'],
          videoTitle: maps[i]['$videoTitle'],
          videoSource: maps[i]['$videoTitle'],
          videoName: maps[i]['$videoName'],
          videoAbout: maps[i]['$videoAbout'],
          videoNote: maps[i]['$videoNote']
      );
    });
  }
  Future<List<VideosModelProvider>> queryAllRecently() async{
    //  screenwidth =width;
    Database db = await instance.database;
    await db.execute(
        '''
        CREATE TABLE IF NOT EXISTS $_recentlyWatched (
       $_columId INTEGER PRIMARY KEY,
       $theme TEXT NOT NULL,
       $videoTitle TEXT,
       $videoSource TEXT,
       $videoName TEXT,
       $videoAbout TEXT,
       $videoNote TEXT,
       $percentage INTEGER
       )

       '''
    );


    final List<Map<String, dynamic>> maps = await db.query(_recentlyWatched);
    return List.generate(maps.length, (i) {
      return VideosModelProvider(
          id: maps[i]['$_columId'],
          theme: maps[i]['$theme'],
          videoTitle: maps[i]['$videoTitle'],
          videoSource: maps[i]['$videoSource'],
          videoName: maps[i]['$videoName'],
          videoAbout: maps[i]['$videoAbout'],
          videoNote: maps[i]['$videoNote']
      );
    });
  }

// Future<VideosModelProvider> getTodo() async {
//   Database db = await instance.database;
//   List<Map> maps = await db.query(_recentlyWatched,
//       columns: [_columId, theme, videoTitle, videoSource, videoName, videoAbout, videoNote],
//       where: '$_columId = ?',
//       whereArgs: [1]);
//      print(maps);
//   if (maps.length > 0) {
//     return VideosModelProvider.fromJson(maps.first);
//   }
//   return null;
// }
}
