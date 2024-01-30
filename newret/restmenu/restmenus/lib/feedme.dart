import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import from youtube_player_flutter

import 'package:restmenus/feedback_model.dart';

class FeedMe extends StatefulWidget {
  const FeedMe({Key? key});

  @override
  State<FeedMe> createState() => _FeedMeState();
}

class _FeedMeState extends State<FeedMe> {
  List<String> lang = ["fish", "hot drinks", "Ethiopian", "france", "Arabic"];
  String selectedLang = "";
  List<FeedbackModel> feedbacks = [];

  late List<String> youtubeVideoIds = [
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
    'kRCH8kD1GD0',
  ];
  late List<YoutubePlayerController> controllers;
  final ScrollController _controller = ScrollController();
  bool stopScrolling = false;
  bool _firstIteration = true;

  void _scrollListView() {
    if (!stopScrolling) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );

      Timer(const Duration(seconds: 2), () {
        _controller.animateTo(
          _controller.position.minScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        );

        if (!_firstIteration) {
          setState(() {
            stopScrolling = true;
          });
        }

        _firstIteration = false;
      });
    }
  }
List jsonfeedback =[];
  getFeedbackFromSheet() async {
    var url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbxTLRLE5HWISOoNa4Lpg_NHcdW-CysDfrWcnOCHFgD31Gx1RYr5RQf1sxuIds1UB6XM/exec');
    var response = await http.get(url);
     jsonfeedback = convert.jsonDecode(response.body);

      List namesList = jsonfeedback[0].map((item) => item['name'].toString()).toList();
  List idsList = jsonfeedback[0].map((item) => item['id'] as int).toList();
  List ingredientsList = jsonfeedback[0].map((item) => item['ingredients'].toString()).toList();
  List  videosList = jsonfeedback[0].map((item) => item['video'].toString()).toList();
  List  photosList = jsonfeedback[0].map((item) => item['photo'].toString()).toList();
  List  pricesList = jsonfeedback[0].map((item) => item['price'] as int).toList();
  

     print(videosList);
  }


  @override
  void initState() {
    super.initState();

    controllers = youtubeVideoIds.map((videoId) {
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          loop: true,
        ),
      );
    }).toList();
    getFeedbackFromSheet();
   //  getcatagorylist();

    Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      _scrollListView();
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double wdth = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: hight * 0.09,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 8, 2, 2),
                    height: hight * 0.3,
                    width: wdth * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLPT2nwd__DulLQ4ZjrIHE2MhXYjUwhrANXg&usqp=CAU",
                        ),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(1, 20, 1, 0),
                    width: wdth * 0.5,
                    height: hight * 0.3,
                    alignment: Alignment.topLeft,
                    child: Text(
                      " \t\t\t\t\t\t\t\t\t\t\t\t\t WELCOME TO  \n \t\t HAILE GRAND ADDIS ABEBA  \n \t\t\t\t\t\t\t\t\t\t\t\t\t FOOD MENU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: wdth * 0.03,
                        color: const Color.fromARGB(255, 12, 56, 92),
                      ),
                    ),
                  ),
                  Container(
                    width: wdth * 0.2,
                    height: hight * 0.3,
                    margin: const EdgeInsets.only(left: 5),
                    child: DropdownButton<String>(
                      items: lang
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: wdth * 0.03,
                                    color: const Color.fromARGB(255, 12, 56, 92),
                                  ),
                                ),
                              ))
                          .toList(),
                      hint: const Text('english'),
                      onChanged: (value) {
                        setState(() {
                          selectedLang = value.toString();
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: wdth,
              height: hight * 0.3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: lang.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 12, 56, 92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 5.0,
                    ),
                    child: Center(
                      child: Text(
                        lang[index],
                        style: TextStyle(
                          fontSize: wdth * 0.03,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: hight * 0.58,
              width: wdth,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: hight * 0.03,
                    width: wdth,
                    child: Text(
                      'house Specials',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: wdth * 0.04,fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: wdth,
                    height: hight * 0.2,
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          stopScrolling = !stopScrolling;
                        });
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _controller,
                        itemCount: youtubeVideoIds.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(1.0),
                            width: wdth * 0.4,
                            height: hight * 0.2,
                            color: Color.fromARGB(255, 134, 131, 131),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    'data',style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    height: hight * 0.1,
                                    color: Colors.purple,
                                    child: YoutubePlayer(
                                      controller: controllers[index],
                                      showVideoProgressIndicator: true,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    '500 ETB', style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: wdth,
                    height: hight * 0.4,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: lang.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            print(lang[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 12, 56, 92),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 5.0,
                          ),
                          child: Center(
                            child: Text(
                              lang[index],
                              style: TextStyle(
                                fontSize: wdth * 0.03,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}