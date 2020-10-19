import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

Map<String,Map<String,String>>topicMap = const {
'TYT':{
'T':'Türkçe',
'M':'Temel Matematik',
'S':'Sosyal Bilimler',
'F':'Fen Bilimleri'
},
'AYT':{
'T2':'Türk Dili ve Edebiyatı Sosyal Bilimler-1',
'M2':'Matematik-2',
'S2':'Sosyal Bilimler-2',
'F2':'Fen Bilimleri-2'
}
};

Map<String,Map<String,String>> subTopicMap= const{
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
};

Map<String,Map<String,String>> subTopicMap2= const{
'T':null,
'M':null,
'S':{
'ST':'Tarih',
'SC':'Coğrafya',
'SF':'Felsefe',
'SD':'Din Kültürü ve Ahlak Bilgisi'
},
'F':{
'FF':'Fizik',
'FK':'Kimya',
'FB':'Biyoloji'
},
'T2':{
'T2E':'Türk Dili ve Edebiyatı',
'T2T':'Tarih',
'T2C':'Coğrafya',
},
'M2':null,
'S2':{
'S2T':'Tarih-2',
'S2C':'Coğrafya-2',
'S2F':'Felsefe Grubu',
'S2D':'Din Kültürü ve Ahlak Bilgisi'
},
'F2':{
'F2F':'Fizik-2',
'F2K':'Kimya-2',
'F2B':'Biyoloji-2'
}
};

Map<String,Color> colorMap  = const {
'T':o.Colors.optikTurkce,
'M':o.Colors.optikMatematik,
'S':o.Colors.optikSosyal,
'F':o.Colors.optikFen,
'T2':o.Colors.optikTurkce,
'M2':o.Colors.optikMatematik,
'S2':o.Colors.optikSosyal,
'F2':o.Colors.optikFen,
};

Map<String,List<Color>> gradientMap  = const {
'T':[o.Colors.optikTurkce,o.Colors.optikTurkce],
'M':[o.Colors.optikMatematik,o.Colors.optikMatematik],
'S':[o.Colors.optikSosyal,o.Colors.optikSosyal],
'F':[o.Colors.optikFen,o.Colors.optikFen],
'T2':[o.Colors.optikTurkce,o.Colors.optikTurkceGradient],
'M2':[o.Colors.optikMatematik,o.Colors.optikMatematikGradient],
'S2':[o.Colors.optikSosyal,o.Colors.optikSosyalGradient],
'F2':[o.Colors.optikFen,o.Colors.optikFenGradient],
};

Map<String,List<String>> aytLists = const {
'EA':['T2','M2'],
'SAY':['M2','F2'],
'SÖZ':['T2','S2'],
'TYT':['-','-']
};

Map<String,dynamic> subTopicMap3= const{
'T':{
'T':'Türkçe'
},
'M':{
'M':'Temel Matematik'
},
'S':{
'ST':'Tarih',
'SC':'Coğrafya',
'SF':'Felsefe',
'SD':'Din Kültürü ve Ahlak Bilgisi'
},
'F':{
'FF':'Fizik',
'FK':'Kimya',
'FB':'Biyoloji'
},
'T2':{
'T2E':'Türk Dili ve Edebiyatı',
'T2T':'Tarih',
'T2C':'Coğrafya',
},
'M2':{
'M2':'Matematik-2'
},
'S2':{
'S2T':'Tarih-2',
'S2C':'Coğrafya-2',
'S2F':'Felsefe Grubu',
'S2D':'Din Kültürü ve Ahlak Bilgisi'
},
'F2':{
'F2F':'Fizik-2',
'F2K':'Kimya-2',
'F2B':'Biyoloji-2'
}
};