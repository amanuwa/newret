class FeedbackModel {
  final String name;
  final int id;
  final String ingredients;
  final String video;
  final String photo;
  final int price;

  FeedbackModel({
    required this.name,
    required this.id,
    required this.ingredients,
    required this.video,
    required this.photo,
    required this.price,
  });

  factory FeedbackModel.fromJson(dynamic json) {
    return FeedbackModel(
      name: "${json['name']}",
      id: json['id'],
      ingredients: "${json['ingredients']}",
      video: "${json['video']}",
      photo: "${json['photo']}",
      price: json['price'],
    );
  }
  Map tojson()=>
{
  "name":name,
  "id":id,
  "ingredients":ingredients,
  "video":video,
  "photo":photo,
  "price":price,


};
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown Button with Hint'),
//       ),
//       body: Center(
//         child: DropdownButton<String>(
//           hint: Text('Select an option'), // Set your hint text here
//           value: selectedValue,
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedValue = newValue;
//             });
//           },
//           items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

