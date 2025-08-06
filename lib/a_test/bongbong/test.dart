// // main.dart
// import 'package:flutter/material.dart';
// import 'package:star_menu/star_menu.dart';
// import 'draggable.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Floating Bubble',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // Bọc MaterialApp bằng một Builder để có context hợp lệ cho Overlay
//       // Hoặc bạn có thể sử dụng một GlobalKey<NavigatorState> cho navigatorKey
//       // và lấy context từ đó.
//       home: Builder(
//           builder: (context) { // Context này có Overlay
//             return const MyHomePage(title: 'Floating Bubble Demo');
//           }
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final centerStarMenuController = StarMenuController();
//   final containerKey = GlobalKey();
//
//   final otherEntries = <Widget>[
//     const FloatingActionButton(
//       onPressed: null,
//       backgroundColor: Colors.black,
//       child: Icon(Icons.add_call),
//     ),
//     const FloatingActionButton(
//       onPressed: null,
//       backgroundColor: Colors.indigo,
//       child: Icon(Icons.adb),
//     ),
//     const FloatingActionButton(
//       onPressed: null,
//       backgroundColor: Colors.purple,
//       child: Icon(Icons.home),
//     ),
//     const FloatingActionButton(
//       onPressed: null,
//       backgroundColor: Colors.blueGrey,
//       child: Icon(Icons.delete),
//     ),
//     // const FloatingActionButton(
//     //   onPressed: null,
//     //   backgroundColor: Colors.deepPurple,
//     //   child: Icon(Icons.get_app),
//     // ),
//   ];
//
//   void _toggleTheBubble() {
//     // Quan trọng: Đảm bảo bạn sử dụng một context có Overlay phía trên nó.
//     // context từ Scaffold.of(context) hoặc context từ builder của một screens
//     // nằm trong cây screens của MaterialApp thường sẽ hoạt động.
//     FloatingBubbleService.toggleBubble(
//       context,
//       child: StarMenu(
//         onStateChanged: (state) {
//           if(state == MenuState.closing) {
//             FloatingBubbleService.visible();
//           }
//           else if(state == MenuState.opening) {
//             FloatingBubbleService.fade();
//           }
//         },
//         controller: centerStarMenuController,
//         items: otherEntries,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _navigateToNewScreen() {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => const NewScreen(),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(screens.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.visibility_off),
//             onPressed: () {
//               if (FloatingBubbleService.isBubbleVisible) {
//                 FloatingBubbleService.hideBubble();
//               } else {
//                 _toggleTheBubble();
//               }
//             },
//             tooltip: 'Hide Bubble',
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Nhấn nút để hiện/ẩn bong bóng:',
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _toggleTheBubble,
//               child: const Text('Toggle Floating Bubble'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _navigateToNewScreen,
//               child: const Text('Go to New Screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Một màn hình mới để kiểm tra xem bong bóng có hiển thị không
// class NewScreen extends StatelessWidget {
//   const NewScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Screen'),
//       ),
//       body: const Center(
//         child: Text(
//           'This is a new screens. The bubble should still be visible and draggable.',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           // Ví dụ: bạn vẫn có thể tương tác với service từ màn hình khác
//           if (FloatingBubbleService.isBubbleVisible) {
//             print("Bubble is visible on NewScreen");
//           }
//         },
//         child: const Icon(Icons.check),
//       ),
//     );
//   }
// }