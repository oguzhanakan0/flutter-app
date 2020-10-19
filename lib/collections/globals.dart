library optik.globals;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

const String address = 'https://server.optikapp.com:1071';
const Map<String,String> headers = {"Content-type": "application/json"};
DateTime GLOBAL_TIME;
String APPSTORE_LINK;
String PLAYSTORE_LINK;
int timeOffset = 0;
int GRACE_PERIOD = 30; // SINAVA GEC KALAN ADAM BU KADAR SANIYE SONRAYA KADAR KABUL EDILIR
int REVIEW_DURATION; // EXAM REVIEW DURATION BUDUR, CONFIGTEN CEKILIR
int RESULT_BUFFER = 10;
int HOLD_DURATION = 10; // SORU ARASI HOLD DURATION BUDUR, CONFIGTEN CEKILIR
int LOBBY_DURATION = 10; // EXAM LOBBY SURESI BUDUR, CONFIGTEN CEKILIR
bool NO_INTERNET = false; // CONNECTIVITY LISTENERI ILE SUREKLI DEGISEBILIR
bool LOBBY_AD = false; // LOBBY AD VAR MI DIYE KONTROL ET
bool PERSISTENT_AD = false; // SORU ARALARINDA AD VAR MI DIYE KONTROL ET
bool ON_EXAM = false; // SINAV ESNASINDA TRUE'YA DONER. REVIEW SAYFASINDAN CIKARKEN FALSE'A DONER.
bool ON_REVIEW = false; // REVIEW ESNASINDA MIYIZ CHECKI
bool SHOW_TODAYS_QUESTION = false;
List<String> LOBBY_INFO_TEXT = [''];
int MAXIMUM_TIME = 120;
String SESSION_ID=''; // USER UNIQUE SESSION ID BUDUR, LOGIN ESNASINDA GELIR
String SIGNIN_METHOD =''; // LOGIN ESNASINDA FIREBASE'DEN DONEN CEVABA GORE BELIRLENIR
String USER_PASSWORD = ''; // COK SPESIFIK BIR DURUM OLARAK, EGER USER EMAIL ILE KAYDOLMUSSA VE TELEFONU DOGRULAMAMISSA PASSWORD ISTENIR. BURASI O ESNADA DOLAR

TextStyle optikCustomTextStyle(dom.Node node, TextStyle baseStyle){
  if (node is dom.Element) {
      switch (node.localName) {
        case "sub":
          return baseStyle.merge(TextStyle(fontSize: 9,height: 1.5));
      }
    }
  return baseStyle.merge(TextStyle(fontSize: 14,height: 1.5));
}