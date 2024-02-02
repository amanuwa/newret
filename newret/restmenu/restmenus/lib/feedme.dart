import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:video_player/video_player.dart';
import 'package:restmenus/feedback_model.dart';
import 'dart:ui_web' as ui; 
import 'package:chewie/chewie.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedMe extends StatefulWidget {
  const FeedMe({Key? key});

  @override
  State<FeedMe> createState() => _FeedMeState();
}

class _FeedMeState extends State<FeedMe> {
  List<String> lang = ["fish", "hot drinks", "Ethiopian", "france", "Arabic"];
  String selectedLang = "";
  List<FeedbackModel> feedbacks = [];

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

  List<dynamic> specialnames = [];
  List<dynamic> specialid = [];
  List<dynamic> specialingredients = [];
  List<dynamic> specialvideos = [];
  List<dynamic> specialprices = [];
  List jsonfeedback = [];
  List catagorylist = [];

  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  getFeedbackFromSheet() async {
    var url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbxTLRLE5HWISOoNa4Lpg_NHcdW-CysDfrWcnOCHFgD31Gx1RYr5RQf1sxuIds1UB6XM/exec');
    var response = await http.get(url);
    jsonfeedback = convert.jsonDecode(response.body);
    print(jsonfeedback.length);
    setState(() {
      catagorylist = 
        jsonfeedback[2].map((item) => item['name'].toString()).toList();
    specialnames =
        jsonfeedback[3].map((item) => item['name'].toString()).toList();
    specialid = jsonfeedback[3].map((item) => item['id'].toString()).toList();
    specialingredients =
        jsonfeedback[3].map((item) => item['ingredients'].toString()).toList();
    specialvideos =
        jsonfeedback[3].map((item) => item['video'].toString()).toList();
    specialprices =
        jsonfeedback[3].map((item) => item['price'].toString()).toList();
    });

    
        print(catagorylist);
  }

  @override
  void initState() {
    super.initState();
    getFeedbackFromSheet();
    initializeVideoPlayers();
  }

 

Future<void> initializeVideoPlayers() async {
  try {
    _controllers = specialvideos
        .map((path) => VideoPlayerController.network(path)..setLooping(true))
        .toList();

    _initializeVideoPlayerFutures =
        _controllers.map((controller) => controller.initialize()).toList();

    await Future.wait(_initializeVideoPlayerFutures);

    setState(() {
      for (var controller in _controllers) {
        controller.play();
        controller.setLooping(true);
        controller.setVolume(0.0);
      }
    });
  } catch (error) {
    print('Error initializing video players: $error');

    // You can add more specific error handling here if needed.
  }
}
int focusedIndex = 0;



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
                itemCount: catagorylist.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      print('$index');
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
                        catagorylist[index],
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
                      'House Special',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: wdth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: wdth,
                    height: hight * 0.2,
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    color: Colors.amber,
                    child: GestureDetector(
                      onTap: () {
                        
                      },
                      
            child: CarouselSlider.builder(
              itemCount: specialvideos.length,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: true, 
                onPageChanged: (index, reason) {
                  setState(() {
                    focusedIndex = index;
                    print('Focused Item Index: $focusedIndex');
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  color: Colors.blue,
                  child: Chewie(
                    controller: ChewieController(
                      videoPlayerController: VideoPlayerController.network(specialvideos[index]),
                      autoPlay: index == focusedIndex,
                      looping: true,
                       showControls: false, // Set to false to hide controls
                        aspectRatio: 9 / 6, // Adjust aspect ratio as needed
                        allowMuting: true,
                         // Allow muting the video
                        // Show mute icon
                        autoInitialize: true,
                      // Other ChewieController options as needed
                    ),
                  
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

// class VideoPlayerItem extends StatefulWidget {
//   final VideoPlayerController controller;

//   const VideoPlayerItem({Key? key, required this.controller});

//   @override
//   _VideoPlayerItemState createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: widget.controller.value.aspectRatio,
//       child: VideoPlayer(widget.controller),
//     );
//   }
// }
