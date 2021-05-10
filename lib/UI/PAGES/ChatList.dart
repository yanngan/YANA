// import 'package:flutter/material.dart';
// import 'package:yana/UI/PAGES/AllPage.dart';
// import 'package:yana/UX/DB/user.dart';
//
// class ChatList extends StatefulWidget {
//    List<User> users = [
//      new User("userName", "userID", "dateOfBirth", "bio", "fbPhoto", "signUpDate", false, false, "nickName", "sex"),
//      new User("userName0", "userID0", "dateOfBirth0", "bio0", "fbPhoto0", "signUpDate0", false, false, "nickName0", "sex0"),
//      new User("userName1", "userID1", "dateOfBirth1", "bio1", "fbPhoto1", "signUpDate1", false, false, "nickName0", "sex0"),
//    ];
//
//    ChatList({
//      required this.users,
//      required Key key,
//    }) : super(key: key);
//
//    @override
//    Widget build(BuildContext context) => Expanded(
//      child: Container(
//        padding: EdgeInsets.all(10),
//        decoration: BoxDecoration(
//          color: Colors.white,
//          borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(25),
//            topRight: Radius.circular(25),
//          ),
//        ),
//        child: buildChats(),
//      ),
//    );
//
//    Widget buildChats() => ListView.builder(
//      physics: BouncingScrollPhysics(),
//      itemBuilder: (context, index) {
//        final user = users[index];
//
//        return Container(
//          height: 75,
//          child: ListTile(
//            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => Chat(user: user),
//              ));
//            },
//            leading: CircleAvatar(
//              radius: 25,
//              backgroundImage: NetworkImage(user.fbPhoto),
//            ),
//            title: Text(user.nickName),
//          ),
//        );
//      },
//      itemCount: users.length,
//    );
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
//   // @override
//   // _ChatListState createState() => _ChatListState();
//
//
// // class _ChatListState extends State<ChatList> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.amber,
// //       child: Center(child: Text("ChatList")),
// //     );
// //   }
// // }
//
//
//
//
//
