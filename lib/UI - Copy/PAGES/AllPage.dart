export 'Chat.dart';
export 'ChatList.dart';
export 'Login.dart';
export 'MapView.dart';
export 'SearchView.dart';
export 'Settings.dart';
export 'Welcome.dart';
export 'SignIn.dart';
export 'NoticeBoard.dart';

/// Developers: Lidor Eliyahu Shelef, Yann Ganem, Yisrael Bar-Or and Jonas Sperling

const appName = "YANA";
bool isOver18 = false;

/* const int Welcome_index   = 0;
 * const int Login_index     = 1;
 * const int SingUp_index    = 2;
 * const int MapView_index   = 3;
 * const int SearchView_index= 4;
 * const int Settings_index  = 5;
 * const int ChatList_index  = 6;
 * const int Chat_index      = 7;
 * const int NoticeBoard_index = 8;
 */

// Correct order: (after Yann see the above, delete the above and use only this below)
const int Chat_index          = 0;
const int SearchView_index    = 1;
const int MapView_index       = 2;
const int NoticeBoard_index   = 3;
const int Settings_index      = 4;
const int Welcome_index       = 5;
const int Login_index         = 6;
const int SingIn_index        = 7;
const int ChatList_index      = 8;


int pageType = 0;
/*
 * int pageType = 0;   --> Welcome Page
 * int pageType = 1;   --> Sign In Page
 * int pageType = 2;   --> Login Page
 * int pageType = 3;   --> Testing
 */

