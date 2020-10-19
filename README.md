# Optik App - Canlı Deneme Oyunu Front End Repository

## Config Elements:
```
- UI: REVIEW_DURATION -->  reviewDuration (int)
- UI: HOLD_DURATION --> holdDuration (int)
- UI: LOBBY_DURATION --> lobbyDuration (int)
- UI: GRACE_PERIOD --> gracePeriod (int)
- UI: MAXIMUM_TIME --> maximumTime (int)
- UI: RESULT_BUFFER --> resultBuffer (int)
- UI: LOBBY_INFO_TEXT --> lobbyText (List<String>)
- UI: APPSTORE_LINK --> appStoreLink (String)
- UI: PLAYSTORE_LINK --> playStoreLink (String)
- UI: SHOW_TODAYS_QUESTION --> showTodaysQuestion (bool)
- UI: N/A --> homepageNotification (String)
- UI: N/A --> updateExists (bool)
- UI: N/A --> updateMandatory (bool)
```

## topic s and subTopic s:
- **T**: T
- **M**: M
- **F**: FF FK FB
- **S**: ST SC SF SD
- **T2**: T2E T2T T2C
- **M2**: M2
- **F2**: F2F F2K F2B
- **S2**: S2T S2C S2F S2D

## DB TODO:

- SPA
- SPB
- Leaderboard Exam
- Leaderboard Test Questions
- User Related:
Login, Signup, Change Info, Forgot Password


## API result format:
Always in the form of:
```
{
    <whatever is necessary, plus the following>
    success: true
}
```
If there is an error:
```
{
    success: false,
    error: "Unauthorized"
}
```
If the main expected result is an array:
```
{
    array: [<results>],
    success: true
}
```

## Backend Services Post Information Requirements:

## Possible Post Fonksiyonları ve Geri Dönmesi Gereken Cevaplar
> Buradaki "post" get/post'takine refer etmiyor. Post = kullanıcının veri gönderdiği fonksiyonlar.

#### 1. sendAnswer({String username, String answer, String questionID}): tekil soru cevabı göndermek için kullanılır. Deneme Soruları kısmında bu istek gönderilir.

Örnek json:

{
	"username":"ogakan",
	"questionID":"346346",
	"answer":"X"
}

Olası cevaplar:
- true: cevap gönderim başarılı
- false: cevap gönderim başarısız

#### 2. sendAnswersInBatch({String username, var qList}): çoklu cevap gönderimi için kullanılır. Exam Review Page'te bu istek gönderilir.

Örnek json:

{
	"username":"ogakan",
	"answList":[
		{
			"questionID":"q1",
			"userChoice":"B"
		},
		{
			"questionID":"q2",
			"userChoice":"C"
		},
		{
			"questionID":"q3",
			"userChoice":"D"
		},
		{
			"questionID":"q4",
			"userChoice":"E"
		}
	]
}

Olası cevaplar:
- true: cevap gönderim başarılı
- false: cevap gönderim başarısız

#### 3. sendLoginInfo({String username, String password}): Giriş yaparken kullanılır.

Örnek json:

{
	"username":username,
	"password":password
}

Olası cevaplar:
- User(): sampleUser.json dosyasındaki gibi bir json dönmeli.
- null: bir hata durumunda null dönmesi lazım ve bu ÖNEMLİ

#### 4. sendAlreadyLoggedInInfo({String deviceID}): Entrance page'te halihazırda giriş yapılmış mı diye kontrol etmek için kullanılır.

Örnek json:
"63463452345234"

Olası cevaplar:
- User(): sampleUser.json dosyasındaki gibi bir json dönmeli.
- null: bir hata durumunda null dönmesi lazım ve bu ÖNEMLİ

#### 5. sendCreateUserInfo({User user}): Signup Form'un son sayfasında yeni kullanıcı yaratmak için gönderilir.

Örnek json:

{
	"id":"1234",
	"username":"ogakan",
	"password":"akan123",
	"phoneNumber":"+905444958169",
	"email":"oakan13@ku.edu.tr",
	"firstName":"Oğuzhan",
	"city":"Çanakkale",
	"lastName":"Akan",
	"areaChoice":"SAY",
	"desiredMajors":["İşletme","Ekonomi"],
	"schoolID":"10001",
	"grade":"12. Sınıf",
	"schoolName":"İstanbul Atatürk Fen Lisesi",
	"displaySchoolName":"İstanbul Atatürk Fen Lisesi",
	"marketingCheck":true
}

Olası cevaplar:
- true: Kullanıcı yaratımı başarılı
- false: Kullanıcı yaratımı başarısız

#### 6. sendHelpMessage({String username, String message, String contactChoice}): Destek mesajı göndermek için kullanılır.

Örnek json:

{
	"username":"ogakan",
	"message":"Merhaba, lisemi değiştirmek istiyorum. Yardım eder misiniz?",
	"contactChoice":"Telefon"
}

Olası cevaplar:
- true: Destek isteği başarılı
- false: Destek isteği başarısız

#### 7. sendChangePasswordInfo({String username, String newPassword, String oldPassword}): Şifre değiştirmek için kullanılır.

Örnek json:

{
	"username":"ogakan",
	"newPassword":"akan321",
	"oldPassword":"akan123"
}

Olası cevaplar:
- "success": şifre başarıyla değiştirildi
- "invalid": eski şifre yanlış girildi
- "error"  : başka bir hata oluştu

#### 8. sendChangeAreaInfo({String username, String areaChoice}): Puan türü seçeneği değiştirmek için kullanılır.

Örnek json:

{
	"username":"ogakan",
	"areaChoice":"SÖZ",
}

Olası cevaplar:
- true: Alan değiştirme isteği başarılı
- false: Alan değiştirme isteği başarısız

#### 9. sendChangeEmailInfo({String username, String newEmail}): Email adresi değiştirmek için kullanılır.

Örnek json:

{
	"username":username,
	"email":newEmail,
}

Olası cevaplar:
- true: email başarıyla değiştirildi
- false: hata oluştu

#### 10. sendForgotPasswordInfo({email}): Şifremi unuttum kısmı için kullanılır.

Örnek json:

"oakan13@ku.edu.tr"

Olası cevaplar:
- true: yeni şifre başarıyla gönderildi.
- false: hata oluştu

# OTHER
## Backend Services Requirements:
1. Entrance Page: (entrance_page.dart)
    1.1. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda user check yapmamız lazım. User logged in ise User objesinin içi dolmalı ve userCheck true'ya dönmeli. 
2. Home Page: (home_page.dart)
    2.1. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda todaysExam, gununSorusu dolmalı.
3. Leaderboard Page: (leaderboard_page.dart)
    > Leaderboard Page Optik Exam: (models/leaderboard_page_optikexam.dart)
        3.1. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda parentExam (bir önceki haftanın parentExam'i), katilimciSayisi, examRankings2, schoolRankings, examHistogramData2, userBuckets (elimizdeki user'ın hangi bucketlarda olduğu), ve netler dolmalı.
    > Leaderboard Page Deneme Soruları: (models/leaderboard_page_denemesorulari.dart)
        3.2. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda _rankingList ve currentUserRanking dolmalı.
4. Schedule Page: (schedule.dart)
        4.1. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda exams dolmalı.
5. Profile Page: (profile_page.dart)
    > Bu Hafta Widget: (profile_page.dart)
        5.1. [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda parentExamName, examList dolmalı.
    > My Results Page: (myresults.dart)
        >> [OĞUZ OK] SPB Page: (spb_page.dart)
        >> [OĞUZ OK] SPA Page: (spa_page.dart)
    > Deneme Soruları Stats Page: (deneme_sorulari_stats_page.dart)
        >> [OĞUZ OK] Histogram: (deneme_sorulari_stats_page.dart)
        >> [OĞUZ OK] SPA Page: (spa_page.dart)
6. Exam Lobby Page: (exam_lobby_page.dart)
    6.1 [OĞUZ OK] onAfterBuild(BuildContext context) fonksiyonunda qList, parentExam ve exam dolmalı.
7. Exam Question Page: (exam_question_page.dart) [NO FETCH NEEDED]
8. Exam Hold Page: (exam_hold_page.dart) [OĞUZ OK]
9. Exam Review Page: (exam_review_page.dart) [NO FETCH NEEDED]
10. Exam Results Page: (exam_results_page.dart) [OĞUZ OK]
11. Deneme Soruları Run Page: (deneme_sorulari_run_page.dart) [NO FETCH NEEDED]
12. Deneme Soruları Question Page: (deneme_sorulari_question_page) [OĞUZ OK]
13. Settings Page: (settings_page.dart)
    > Change Password Page: (change_password_page.dart)
    > Change Area Page: (change_area_page.dart)
    > Change Email Page: (change_email_page.dart)
    > How Page: (how_page.dart) [OĞUZ OK]
    > Help Page (help_page.dart) [NO FETCH NEEDED]
14. Login Page: (welcome_page.dart) [NO FETCH NEEDED]
15. Signup Pages:
    > (1) Signup Page: (signup_form.dart) [NO FETCH NEEDED]
    > (2) Signup Page Enter Phone: (signup_form_enter_phone.dart) [NO FETCH NEEDED]
    > (3) Signup Page Verify Phone: (signup_form_verify_phone.dart) [NO FETCH NEEDED]
    > (4) Signup Page Enter Demographics: (signup_form_demographics.dart) [NO FETCH NEEDED]
    > (5) Signup Page Enter Demoographics Continued: (signup_form_demographics_cont.dart) [NO FETCH NEEDED] [POST FUNCTION ADDED]
16. Forgot Password Page: (forgot_password_page.dart) [NO FETCH NEEDED]
17. App Body: (models/app_body.dart) [OĞUZ OK]
