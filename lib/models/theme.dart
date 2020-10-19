import 'package:Optik/collections/avatar.dart';
import 'package:flutter/material.dart';

class Colors {
  static const Color optikBlack = const Color (0xff141414);
  /* static const Color optikGray = const Color (0xffe1dedc); */  
  static const Color optikGray = const Color (0xff808080);
  static const Color optikLightGray = const Color (0xfff9f9f9);
  static const Color optikGreen = const Color (0xff43A047);
  static const Color optikBlue = const Color (0xff2196f3); // 0xff428bca
  static const Color optikDarkBlue = const Color (0xff214565);
  static const Color optikLightBlue = const Color (0xffc6dcef);
  static const Color optikWhite = const Color (0xffffffff);
  static const Color optikBorder = const Color(0xffD5DBDB);
  static const Color optikYellow = const Color (0xFFF7DC6F);

  static const Color optikTurkce = const Color (0xffDC143C);
  static const Color optikMatematik = const Color (0xff1E90FF);
  static const Color optikSosyal = const Color (0xfff79d00);
  static const Color optikFen = const Color (0xff2E8B57);
  static const Color optikTurkceGradient = const Color (0xff9a0e2a);
  static const Color optikMatematikGradient = const Color (0xff1564b2);
  static const Color optikSosyalGradient = const Color (0xffdb9314);
  static const Color optikFenGradient = const Color (0xff20613c);
  /* static const Color optikContainerBg = const Color (0xffefebe9); # Kahverengi BG
  static const Color optikButton1 = const Color (0xff424242); # Kajverengi Button
  static const Color optikButton1Disabled = const Color (0xff757575); # Gri BUTTON Disabled */
  static const Color optikContainerBg = const Color (0xffefebe9);
  static const Color optikButton1 = const Color (0xff428bca);
  static const Color optikButton1Disabled = const Color (0xfff9f9f9);
  static const Map<String, Map<String,Color>> optikHistogramColors = {
    'Genel':
{'≥0':Color (0xffc53d18),
'≥10':Color (0xffd45e14),
'≥20':Color (0xffe27f10),
'≥30':Color (0xfff1a00c),
'≥40':Color (0xffffc107),
'≥50':Color (0xffccc216),
'≥60':Color (0xff99c425),
'≥70':Color (0xff66c534),
'≥80':Color (0xff33c744),
'≥90':Color (0xff00c853)},
'T':{
'≥0':Color (0xffc53d18),
'≥2':Color (0xffd45e14),
'≥4':Color (0xffe27f10),
'≥6':Color (0xfff1a00c),
'≥8':Color (0xffffc107),
'≥10':Color (0xffccc216),
'≥12':Color (0xff99c425),
'≥14':Color (0xff66c534),
'≥16':Color (0xff33c744),
'≥18':Color (0xff00c853)},
'S':
{'0':Color (0xffc53d18),
'1':Color (0xffc53d18),
'2':Color (0xffd45e14),
'3':Color (0xffe27f10),
'4':Color (0xfff1a00c),
'5':Color (0xffffc107),
'6':Color (0xffccc216),
'7':Color (0xff99c425),
'8':Color (0xff66c534),
'9':Color (0xff33c744),
'10':Color (0xff00c853)}
  };
  static const Color optikHistogram1 = const Color (0xffc53d18);
  static const Color optikHistogram2 = const Color (0xffd45e14);
  static const Color optikHistogram3 = const Color (0xffe27f10);
  static const Color optikHistogram4 = const Color (0xfff1a00c);
  static const Color optikHistogram5 = const Color (0xffffc107);
  static const Color optikHistogram6 = const Color (0xffccc216);
  static const Color optikHistogram7 = const Color (0xff99c425);
  static const Color optikHistogram8 = const Color (0xff66c534);
  static const Color optikHistogram9 = const Color (0xff33c744);
  static const Color optikHistogram10 = const Color (0xff00c853);// most green
}

class FontSizes {
  static const double bir = 48.0;
  static const double iki = 36.0;
  static const double uc = 18.0;
  static const double dort = 16.0;
  static const double bes = 14.0;
  static const double alti = 12.0;
}

class TextStyles {
  static const TextStyle optikHeader = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.bir,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);
  
  static const TextStyle optikHeaderWhite = TextStyle(
    color: Colors.optikWhite,
    fontSize: FontSizes.bir,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikSubHead = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.iki,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikSubHeadBold = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.iki,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    /* fontFamily: _ff */);

  static const TextStyle optikTitle = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.uc,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBoldTitle = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.uc,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    /* fontFamily: _ff */);

  static const TextStyle optikWhiteTitle = TextStyle(
    color: Colors.optikWhite,
    fontSize: FontSizes.uc,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikSubTitle = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.dort,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBody1 = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.bes,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBody1White = TextStyle(
    color: Colors.optikWhite,
    fontSize: FontSizes.bes,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBody1Bold = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.bes,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    /* fontFamily: _ff */);

  static const TextStyle optikBody1BoldUnderlined = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.bes,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.underline,
    /* fontFamily: _ff */);
  
  static const TextStyle optikBody1BoldWhite = TextStyle(
    color: Colors.optikWhite,
    fontSize: FontSizes.bes,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    /* fontFamily: _ff */);

  static const TextStyle optikBody2 = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.alti,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBody2White = TextStyle(
    color: Colors.optikWhite,
    fontSize: FontSizes.alti,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    /* fontFamily: _ff */);

  static const TextStyle optikBody2Bold = TextStyle(
    color: Colors.optikBlack,
    fontSize: FontSizes.alti,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    /* fontFamily: _ff */);
}

/* decoration: TextDecoration.underline */

Map<int,Avatar> avatarMap = {
0:Avatar(name:'Avatar seçin',path:'assets/images/avatar/select.png'),
1:Avatar(name:'Aristoteles',path:'assets/images/avatar/aristo.png'),
2:Avatar(name:'Aziz Sancar',path:'assets/images/avatar/aziz.png'),
3:Avatar(name:'Niels Bohr',path:'assets/images/avatar/bohr.png'),
4:Avatar(name:'Marie Curie',path:'assets/images/avatar/curie.png'),
5:Avatar(name:'Leonardo da Vinci',path:'assets/images/avatar/davinci.png'),
6:Avatar(name:'René Descartes',path:'assets/images/avatar/descartes.png'),
7:Avatar(name:'Fyodor Dostoyevski',path:'assets/images/avatar/dostoyevski.png'),
8:Avatar(name:'Thomas Edison',path:'assets/images/avatar/edison.png'),
9:Avatar(name:'Albert Einstein',path:'assets/images/avatar/einstein.png'),
10:Avatar(name:'Michael Faraday',path:'assets/images/avatar/faraday.png'),
11:Avatar(name:'Rosalind Franklin',path:'assets/images/avatar/franklin.png'),
12:Avatar(name:'Galileo Galilei',path:'assets/images/avatar/galileo.png'),
13:Avatar(name:'Stephen Hawking',path:'assets/images/avatar/hawking.png'),
14:Avatar(name:'Ernest Hemingway',path:'assets/images/avatar/hemingway.png'),
15:Avatar(name:'Jane Austen',path:'assets/images/avatar/jane.png'),
16:Avatar(name:'Franz Kafka',path:'assets/images/avatar/kafka.png'),
17:Avatar(name:'Gabriel García Márquez',path:'assets/images/avatar/marquez.png'),
18:Avatar(name:'Isaac Newton',path:'assets/images/avatar/newton.png'),
19:Avatar(name:'Orhan Pamuk',path:'assets/images/avatar/pamuk.png'),
20:Avatar(name:'Louis Pasteur',path:'assets/images/avatar/pasteur.png'),
21:Avatar(name:'William Shakespeare',path:'assets/images/avatar/shakespeare.png'),
22:Avatar(name:'Nikola Tesla',path:'assets/images/avatar/tesla.png'),
23:Avatar(name:'Leo Tolstoy',path:'assets/images/avatar/tolstoy.png'),
24:Avatar(name:'Virginia Woolf',path:'assets/images/avatar/woolf.png')
};