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

// Application Constant Keys

const appName                       =   "YANA";
bool isOver18                       =   false;
const String NeumorphismInner       =   'NEUMORPHISM_INNER';
const String NeumorphismOuter       =   'NEUMORPHISM_OUTER';
const String NeumorphismOuterChip   =   'NEUMORPHISM_OUTER_CHIP';
const bodyColor                     =   Colors.amber;
const senderColor                   =   bodyColor;
const receiverColor                 =   Colors.purple;

// Pages indexes
const int ChatsAndEvents_index      =   0;
const int SearchView_index          =   1;
const int MapView_index             =   2;
const int NoticeBoard_index         =   3;
const int Settings_index            =   4;
const int Welcome_index             =   5;
const int Login_index               =   6;
const int SingUp_index              =   7;
const int ChatList_index            =   8;
// Determine which page will be displayed to the user
int pageType                        =   0;
/*
 * int pageType = 0;   --> Welcome Page
 * int pageType = 1;   --> Sign In Page
 * int pageType = 2;   --> Login Page
 * int pageType = 3;   --> Inner App
 * int pageType = 10;  --> Testing
 */
// User information will be stored in here
Map<String, String> userMap         =   new Map<String, String>();
Map<String, String> otherInfo       =   new Map<String, String>();

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling
