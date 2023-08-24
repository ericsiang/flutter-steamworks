import 'package:flutter/material.dart';
import 'package:steamworks/steamworks.dart';
import "dart:ffi";
import "package:ffi/ffi.dart";

void main() async {
  SteamClient.init();
  SteamClient steamClient = SteamClient.instance;

  CSteamId steamId = steamClient.steamUser.getSteamId();
  int appId = steamClient.steamUtils.getAppId();

  print("SteamId: $steamId");

  /***** 一般功能 *****/
  //檢查用戶有沒有安裝主程式
  bool isAppInstalled = steamClient.steamApps.isAppInstalled(appId);
  print("isAppInstalled: $isAppInstalled");

  //檢查用戶有沒有開啟Steam雲端服務
  bool isCloudEnabledForApp =
      steamClient.steamRemoteStorage.isCloudEnabledForApp();
  print("isCloudEnabledForApp: $isCloudEnabledForApp");

  //開啟用戶的Steam雲端服務
  //bool setCloudEnabledForApp = steamClient.steamRemoteStorage.setCloudEnabledForApp(true);

  //關閉遊戲

  /***** Steam Auto-Cloud *****/
  //刪除 => 刪除功能應該只會在測試階段使用，一般使用者不會用到
  //steamClient.steamRemoteStorage.fileForget();

  /*****  統計與成就 *****/

  //在遊戲階段一開始，從 Steam 後端擷取使用者統計和成就資料
  print('--------------------- START ---------------------');

  //取得該apiName的統計資料
  int getStatInt(String apiName) {
    print("getStatInt32");
    final pchName = "$apiName".toNativeUtf8();
    final Pointer<Int> intPointer = calloc<Int>();
    final getStatInt32Result =
        steamClient.steamUserStats.getStatInt32(pchName, intPointer);
    print("getStatInt32Result:$getStatInt32Result");
    print("intPointer:${intPointer.value}");
    final int value = intPointer.value;

    return value;
  }

  //將該apiName的統計自動＋1
  void setStatInt(String apiName, int score) {
    print("=============setStatInt start===========");
    final pchName = "$apiName".toNativeUtf8();
    final Pointer<Int> intPointer = calloc<Int>();
    score++;
    print("score:$score");
    print("setStatInt32");
    final setStatInt32Result =
        steamClient.steamUserStats.setStatInt32(pchName, score);
    print("setStatInt32Result:$setStatInt32Result");

    print("storeStats");
    final storeStatsResult = steamClient.steamUserStats.storeStats();
    print("storeStatsResult:$storeStatsResult");
    print("=============setStatInt end===========");
  }

  //重置所有統計資料
  void resetStats() {
    print("resetStats");
    final resetStatsResult = steamClient.steamUserStats.resetAllStats(true);
    print("resetStatsResult:$resetStatsResult");

    print("resetStoreStats");
    final resetStoreStatsResult = steamClient.steamUserStats.storeStats();
    print("resetStoreStatsResult:$resetStoreStatsResult");
  }


  void getAchievement() {
    print("=============getAchievement start===========");
    print("getAchievement");
    final pchName2 = "silver".toNativeUtf8();
    final pbAchieved = false;
    Pointer<Bool> boolPointer = Pointer<Bool>.fromAddress(pbAchieved ? 1 : 0);
    final getAchievementResult =
        steamClient.steamUserStats.getAchievement(pchName2, boolPointer);
    print("getAchievementResult:$getAchievementResult");
    print("=============getAchievement end===========");
  }

  //在執行統計相關api時，需先執行requestCurrentStats函式(EX:getStatInt、setStatInt、storeStat)
  if (steamClient.steamUserStats.requestCurrentStats()) {
    print("requestCurrentStats sccusss");

    final int currentScore = getStatInt('silver_test');
    //setStatInt('bronze_test', currentScore);
    setStatInt('silver_test', currentScore);
    //setStatInt('ACH_TRAVEL_FAR_ACCUM', currentScore);
    //resetStats();
    // getAchievement();
  } else {
    print("requestCurrentStats failed");
  }

  print('-------------------- END ----------------------');

  /*****  DLC *****/
  //查看用戶有沒有安裝DLC
  bool isDlcInstalled = steamClient.steamApps.isDlcInstalled(appId);
  print("isDlcInstalled: $isDlcInstalled");


  //回呼調用
  /*
  Callback cb1 = steamClient.registerCallback<UserStatsReceived>(
    cb: (ptrPersona) {
      print("UserStatsReceived");
      print("gameId: ${ptrPersona.gameId}");
      print("result: ${ptrPersona.result}");
      print("SteamIdUser: ${ptrPersona.steamIdUser}");
    },
  );

  SteamApiCall callId = steamClient.steamUserStats.requestUserStats(steamId);
  print("SteamApiCall first: $callId");

  
  CallResult cr1 = steamClient.registerCallResult<UserStatsReceived>(
    asyncCallId: callId,
    cb: (ptrUserStatus, hasFailed) {
      print("User stats first : $hasFailed");
      print("hasFailed: ${hasFailed}");
      print("Request: ${ptrUserStatus}");
      print("GameId: ${ptrUserStatus.gameId}");
      print("SteamIdUser: ${ptrUserStatus.steamIdUser}");
    },
  );

  callId = steamClient.steamUserStats.getNumberOfCurrentPlayers();
  print("SteamApiCall second: $callId");

  CallResult cr2 = steamClient.registerCallResult<UserStatsReceived>(
    asyncCallId: callId,
    cb: (ptrUserStatus, hasFailed) {
      print("User stats second");
      print("GameId: ${ptrUserStatus.gameId}");
      print("SteamIdUser: ${ptrUserStatus.steamIdUser}");
    },
  );

  Callback cb3 = steamClient.registerCallback<PersonaStateChange>(
    cb: (ptrPersona) {
      print("Persona state changed");
      print("SteamId: ${ptrPersona.steamId}");
      print("ChangeFlags: ${ptrPersona.changeFlags}");
    },
  );
  */
  
  runApp(const MyApp());

  //有調用回呼才要開啟使用
  // while (true) {
  //   //無限迴圈持續執行
  //   steamClient.runFrame(); //加此函式，回呼才會被觸發
  //   print("Running frames");
  //   //runApp(const MyApp());
  //   await Future<void>.delayed(const Duration(milliseconds: 300)); //延遲300毫秒
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    SteamClient steamClient = SteamClient.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(steamClient.steamUser.getSteamId().toString()),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
