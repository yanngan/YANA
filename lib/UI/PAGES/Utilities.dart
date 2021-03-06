import 'package:flutter/material.dart';

// Export all the pages
export 'Chat.dart';
export 'ChatList.dart';
export 'Login.dart';
export 'MapView.dart';
export 'SearchView.dart';
export 'Settings.dart';
export 'Welcome.dart';
export 'SignUp.dart';
export 'NoticeBoard.dart';
export 'EventsList.dart';
export 'ChatList.dart';
export 'ChatsAndEvents.dart';
export 'NotificationPage.dart';

/// Application Constant Keys
const appName                       =   "YANA";
const MAP_TYPE_KEY                  =   "MAP_TYPE";
const CHATS_EVENTS_TYPE_KEY         =   "CHATS_EVENTS_TYPE";
const NOTIFICATIONS_KEY             =   "NOTIFICATIONS_KEY";
const String NeumorphismInner       =   'NEUMORPHISM_INNER';
const String NeumorphismOuter       =   'NEUMORPHISM_OUTER';
const String NeumorphismOuterChip   =   'NEUMORPHISM_OUTER_CHIP';
const String NotificationTitle      =    'הודעה חדשה';
const String specialistNumberCall   =   "tel://0523358539";
const String specialistNumberSms    =   "972523558539";
const bodyColor                     =   Colors.amber;
const senderColor                   =   bodyColor;
const receiverColor                 =   Colors.pink;
const double appBarHeight           =   110.0;
bool isOver18                       =   false;
bool defaultMapType                 =   false;
bool whichPage                      =   false;

/// Pages indexes
const int ChatsAndEvents_index      =   0;
const int SearchView_index          =   1;
const int MapView_index             =   2;
const int NoticeBoard_index         =   3;
const int Settings_index            =   4;
const int Welcome_index             =   5;
const int Login_index               =   6;
const int SingUp_index              =   7;
const int Chat_index                =   8;
/// Determine which page will be displayed to the user
int pageType                        =   0;
/*
 * int pageType = 0;   --> Welcome Page
 * int pageType = 1;   --> Sign In Page
 * int pageType = 2;   --> Login Page
 * int pageType = 3;   --> Inner App
 * int pageType = 10;  --> Testing
 */

/// This User information will be stored in here
Map<String, String> userMap         =   new Map<String, String>();
/// Other User information will be stored in here
Map<String, String> otherInfo       =   new Map<String, String>();

/// [appName] about text [String]
String aboutOrganization = "מיזם YANA הינו מיזם למלחמה בבדידות בקרב צעירים. "
    "המיזם נועד ליצור מעגלים חברתיים חדשים עבור מי שאין להם ו/או שמעוניינים ליצור חברויות חדשות."
    "המיזם פועל במספר מישורים בהם אפליקציה ליזימת והצטרפות לאירועים חברתיים מבוססי מיקום; אירועים חברתיים עבור צעירים בודדים כגון סדנאות, שיעורים ועוד; "
    "והקמת מאהלים חברתיים בנקודות מפתח (חוף הים, אוניברסיטה ועוד)."
    "המיזם מיועד לצעירים בגילאי 18 עד 35 (פלוס מינוס).";

/// [developersInfo]  - Application developers [Map] holding the developers names + LinkedIn statement
/// [developersLinks]  - Holding the developers LinkedIn links based on their names
Map<String, String> developersInfo = {
  "לידור אליהו שלף": "ללינקדאין של לידור",
  "יאן משה גנם": "ללינקדאין של יאן",
  "ישראל בר אור": "ללינקדאין של ישראל",
  "ג'ונאס ספרלינג": "ללינקדאין של ג'ונאס",
};
Map<String, String> developersLinks = {
  "Lidor" : "https://www.linkedin.com/in/lidor-e-s/",
  "Yann" : "https://www.linkedin.com/in/yann-ganem-00ab02183/",
  "Yisrael" : "https://www.linkedin.com/in/yisrael-bar-7534a842/",
  "Jonas" : "https://www.linkedin.com/in/jonas-s-32927b20b/",
};


/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling
