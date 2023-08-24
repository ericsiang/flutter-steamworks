---
title: Flutter Plugin 調用 Steam SDK API
date: 2023-08-24
categories:
- Steam Flutter
tags:
- Steam Flutter

---
# Flutter Plugin 調用 Steam SDK API
###### tags: `Steam` `Flutter`
>製作者：Ericsiang


參考：
* [BLKKKBVSIK/steamworks-dart Flutter Steam SDK Plugin](https://github.com/BLKKKBVSIK/steamworks-dart/blob/main/lib/main.dart)
* [aeb-dev/steamworks Flutter Steam SDK Plugin](https://github.com/aeb-dev/steamworks/blob/main/example/bin/example.dart)
* [Flutter 官方 Building macOS apps with Flutter](https://docs.flutter.dev/platform-integration/macos/building)
* [Flutter 官方 Binding to native macOS code using dart:ffi](https://docs.flutter.dev/platform-integration/macos/c-interop)
* [Steam SDK API 的官方操作頁面](https://partner.steamgames.com/doc/sdk)
* [Steam SDK API 官方-統計與成就](https://partner.steamgames.com/doc/features/achievements)


###  步驟一
從 git 上 clone Example 專案下來
```
git clone https://github.com/ericsiang/flutter-steamworks
```
到 flutter-steamworks 資料夾下
```
cd flutter-steamworks
```
將 steam_appid.txt 內的 AppID 改成自己steam上架後台的 AppID
> 原檔下的 AppID 480，是steam 提供測試用的 AppID


###  步驟二
到 [Steam 開發者後台](https://partner.steamgames.com/) 設定統計跟成就，建立 API 名稱，才能用 Steam SDK API 調用，下圖為範例
#### 統計：
![](https://hackmd-prod-images.s3-ap-northeast-1.amazonaws.com/uploads/upload_01ebfa5ce66c502c158634d0ae74d765.png?AWSAccessKeyId=AKIA3XSAAW6AWSKNINWO&Expires=1692865338&Signature=SF4fPMy7ou78M2KidK2akQRDlPc%3D)

#### 成就：
* 設定跟哪個統計相關連，當該統計達標，會自動解鎖關連的成就，從尚未達成圖示，顯示成已達成的圖示
![](https://hackmd-prod-images.s3-ap-northeast-1.amazonaws.com/uploads/upload_fed0d0df1a43c2d1e4c516953cf789dc.png?AWSAccessKeyId=AKIA3XSAAW6AWSKNINWO&Expires=1692865371&Signature=ri68%2FkC2fvaqapIm0EbdjsnSZj4%3D)


### 步驟三
開啟 git 內的 lib/main.dart，該檔有範例

該檔內使用到的 Steam API :
* 檢查用戶有沒有安裝主程式
* 檢查用戶有沒有開啟Steam雲端服務
* 開啟用戶的Steam雲端服務
* 取得目前使用者該 API 名稱的統計資料
* 設定目前使用者該 API 名稱的統計資料
* 重置所有統計資料
* 查看用戶有沒有安裝DLC
* 回呼的調用方式


### 備註
* 有將 macos/Runner/DebugProfile.entitlements 檔的 app-sandbox 設定為 false，因為原本設定 true 會導致無法讀取 libsteam_api.dylib 的檔，尚無找到解決方法，以此將此參數設定為 false，關閉 sandbox 模式
    ```
    <key>com.apple.security.app-sandbox</key>
    <false/>
    ```