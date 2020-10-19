import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/collections/question.dart';
import 'package:Optik/models/question_widget.dart';


/* Classes in this file 

SchedulePage --> Schedule sayfasinin tamami (stateless)
Schedule --> Schedule sayfasinin tamami (stateful)

*/

class SPA extends StatefulWidget {
  // a property on this class
  final String username;
  final String examID;
  final String parentExamID;
  final String parentExamName;
  final String title;
  SPA({
    Key key,
    this.username, 
    this.examID,
    this.title,
    this.parentExamID,
    this.parentExamName}) : super(key: key);
  @override
  _SPAState createState() => _SPAState();
}

class _SPAState extends State<SPA> {
  
  Theme getScheduleItem(Question question, ThemeData theme) {
    final _width = MediaQuery.of(context).size.width;
    final _userChoiceChild = Container(
      width: _width/18,
      height: _width/18,
      decoration: new BoxDecoration(
        color: question.userChoice =='X'?
          o.Colors.optikHistogram4: // if empty
            question.userChoice == question.correctChoice ? 
              o.Colors.optikHistogram9: // if correct
                o.Colors.optikHistogram1, // if incorrect
        shape: BoxShape.circle),
      child: Center(
        child:Text(
          question.userChoice=='X'?'':question.userChoice,
          style: o.TextStyles.optikBody1BoldWhite)),
    );
    final _correctChoiceChild = Container(
      width: _width/18,
      height: _width/18,
      decoration: new BoxDecoration(
        color: o.Colors.optikHistogram9,
        shape: BoxShape.circle),
      child: Center(
        child:Text(
          question.correctChoice,
          style: o.TextStyles.optikBody1BoldWhite)),
    );
    return Theme(data: theme, child:Container(
      decoration: BoxDecoration(
        color: o.Colors.optikWhite,
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom: 4.0),
      child:ExpansionTile(
        key: PageStorageKey('examScrollable'+question.order.toString()),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            SizedBox(width:_width/18, child:Text(question.order.toString(),style: o.TextStyles.optikBody1)),
            SizedBox(width:_width*2/5, child:Text(question.subject,style: o.TextStyles.optikBody1)),
            _userChoiceChild,
            _correctChoiceChild,
            SizedBox(width:_width/18, child:question.userChoice == question.correctChoice ? Icon(Icons.check,color: o.Colors.optikHistogram10,): Icon(Icons.close,color: o.Colors.optikHistogram1))
          ]),
        children: [
            QuestionWidget(
              q: question,
              highlight: true,
            )
        ],
      )
    ));
  }

  Container getOverallResultNumbers(String username, String examID) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: o.Colors.optikWhite,
      padding: EdgeInsets.only(top:8.0,bottom: 8.0),
      child:Table(
        children: [
          TableRow(
            children: [ 
              Center(child:Text('Toplam',style: o.TextStyles.optikBody2)),
              Center(child:Text('Doğru',style: o.TextStyles.optikBody2)),
              Center(child:Text('Yanlış',style: o.TextStyles.optikBody2)),
              Center(child:Text('Boş',style: o.TextStyles.optikBody2)),
              Center(child:Text('Net',style: o.TextStyles.optikBody2)),
          ]),
          TableRow(
            children: [
              Center(child:Text('140',style: o.TextStyles.optikBody1Bold)),
              Center(child:Text('86',style: o.TextStyles.optikBody1Bold)),
              Center(child:Text('34',style: o.TextStyles.optikBody1Bold)),
              Center(child:Text('20',style: o.TextStyles.optikBody1Bold)),
              Center(child:Text('83.25',style: o.TextStyles.optikBody1Bold)),
          ]),
        ],
      )
    );
  }

  ListView _buildList(context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.white.withAlpha(0));
    List<Question> questions = [
      Question(
        questionID: 'q1',
        examID:'e1',
        parentExamID:'pe1',
        header1:'Nullam a posuere purus, vitae pulvinar ipsum. Sed erat lorem, tempor in est ac, vehicula tristique massa. Suspendisse potenti. Sed et pellentesque ex, facilisis mollis augue. Etiam et enim faucibus, pulvinar lectus eget, lacinia arcu. Mauris porta mattis nunc, non aliquam tellus euismod in. Aliquam vel gravida risus. Curabitur enim felis, tincidunt in ullamcorper nec, iaculis sed mauris.',
        body: 'Aliquam tempus accumsan neque sit amet posuere. Integer eu ornare metus?',
        choices:{
          'A':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula ultrices ante, quis pulvinar elit malesuada a. Praesent efficitur ac metus nec pretium. Etiam at tempus sapien.',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'A',
        userChoice: 'X',
        order:1,
        subject: 'Sayılar ve Kümeler ve Trigonometri ve Üçgenler',
        parentSubject: 'TYT',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_014GhzFS2IuObLDhGkf3UkNaVJK2eiwWc0zp0EWucCLQtQwW&s'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'A',
        order: 2,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'X',
        order: 3,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'D',
        userChoice: 'C',
        order: 4,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 5,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 6,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 7,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 8,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 9,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 10,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 11,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
      Question(questionID: 'q2',
        examID:'e2',
        parentExamID:'pe2',
        body:'Soru Body 2',
        choices:{
          'A':'Choice A',
          'B':'Choice B',
          'C':'Choice C',
          'D':'Choice D',
          'E':'Choice E'},
        correctChoice:'C',
        userChoice: 'C',
        order: 12,
        subject: 'Sayılar',
        parentSubject: 'TYT'),
    ];
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, question) {
        return getScheduleItem(questions[question],theme);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
          margin: EdgeInsets.only(top:8.0),
          child:Column(
            children:[
              Text('TYT Türkçe',style: o.TextStyles.optikTitle),
              Text('9 Aralık 2019',style: o.TextStyles.optikBody2Bold)
            ]
          )
        ),
        getOverallResultNumbers(widget.username, widget.examID),
        Divider(thickness: 1.0,height: 0.0,),
        Expanded(
          child:_buildList(context)
        )
      ]
    );
  }
}