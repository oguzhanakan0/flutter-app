import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class DenemeSorulariPageArgs {
  String parentTopicChoice;
  String topicChoice;
  String subTopicChoice;
  String subTopicCode;
  String username;
  String userID;
  int qCount;
  int nCorrect;
  int nIncorrect;
  int nEmpty;
  Map<String,Map<String,String>> topicMap;
  Map<String,Map<String,String>> subTopicMap;
  Map<String,Color> colorMap;
  DenemeSorulariPageArgs({
    this.parentTopicChoice,
    this.topicChoice,
    this.subTopicChoice,
    this.subTopicCode,
    this.username,
    this.userID,
    this.qCount = 0,
    this.nCorrect = 0,
    this.nIncorrect = 0,
    this.nEmpty = 0,
    this.topicMap = const {
      'TYT':{
        'Türkçe':'T',
        'Temel Matematik':'M',
        'Sosyal Bilimler':'S',
        'Fen Bilimleri':'F'
      },
      'AYT':{
        'Türk Dili ve Edebiyatı Sosyal Bilimler-1':'T2',
        'Matematik-2':'M2',
        'Sosyal Bilimler-2':'S2',
        'Fen Bilimleri-2':'F2'
      }
    },
    this.subTopicMap= const{
      'Türkçe':null,
      'Temel Matematik':null,
      'Sosyal Bilimler':{
        'Tarih':'ST',
        'Coğrafya':'SC',
        'Felsefe':'SF',
        'Din Kültürü ve Ahlak Bilgisi':'SD',
      },
      'Fen Bilimleri':{
        'Fizik':'FF',
        'Kimya':'FK',
        'Biyoloji':'FB'
      },
      'Türk Dili ve Edebiyatı Sosyal Bilimler-1':{
        'Türk Dili ve Edebiyatı':'T2E',
        'Tarih':'T2T',
        'Coğrafya':'T2C'
      },
      'Matematik-2':null,
      'Sosyal Bilimler-2':{
        'Tarih-2':'S2T',
        'Coğrafya-2':'S2C',
        'Felsefe Grubu':'S2F',
        'Din Kültürü ve Ahlak Bilgisi':'S2D'
      },
      'Fen Bilimleri-2':{
        'Fizik-2':'F2F',
        'Kimya-2':'F2K',
        'Biyoloji-2':'F2B'
      }
    },
    this.colorMap  = const {
      'T':o.Colors.optikTurkce,
      'M':o.Colors.optikMatematik,
      'S':o.Colors.optikSosyal,
      'F':o.Colors.optikFen,
      'T2':o.Colors.optikTurkce,
      'M2':o.Colors.optikMatematik,
      'S2':o.Colors.optikSosyal,
      'F2':o.Colors.optikFen,
      }
    }
  );
}