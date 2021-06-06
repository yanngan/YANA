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

// Application Constant Keys
const appName                       =   "YANA";
const MAP_TYPE_KEY                  =   "MAP_TYPE";
const CHATS_EVENTS_TYPE_KEY         =   "CHATS_EVENTS_TYPE";
const String NeumorphismInner       =   'NEUMORPHISM_INNER';
const String NeumorphismOuter       =   'NEUMORPHISM_OUTER';
const String NeumorphismOuterChip   =   'NEUMORPHISM_OUTER_CHIP';
const String NotificationTitle      =    'הודעה חדשה';
const String specialistNumberCall   =   "tel://0523358539";
const String specialistNumberSms    =   "972523558539";
const bodyColor                     =   Colors.amber;
const senderColor                   =   bodyColor;
const receiverColor                 =   Colors.pink;
bool isOver18                       =   false;
bool defaultMapType                 =   false;
bool whichPage                      =   false;

// Pages indexes
const int ChatsAndEvents_index      =   0;
const int SearchView_index          =   1;
const int MapView_index             =   2;
const int NoticeBoard_index         =   3;
const int Settings_index            =   4;
const int Welcome_index             =   5;
const int Login_index               =   6;
const int SingUp_index              =   7;
const int Chat_index                =   8;
// Determine which page will be displayed to the user
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

/// [appName] about text
String aboutOrganization = "YANA is a social initiative intended to fight "
    "against loneliness amongst young adults at the ages of 18-35(+-)."
    "This project is meant to help people create new social circles within "
    "safe spaces. This project will take place through an app where young "
    "adults can update their location in any of the YANA supporting businesses, "
    "and invite friends from the YANA platform to come and join then for "
    "a meeting / drink / meal etc...\nWe are looking for the participation "
    "of as many different types of people from different places in Israel "
    "in order to maximize exposure and help as many individuals as possible.";

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling
