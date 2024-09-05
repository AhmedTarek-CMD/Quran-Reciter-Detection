import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:quran/features/domain/entity/SearchData.dart';
import 'package:quran/features/presentation/bloc/main_bloc.dart';
import 'package:quran/features/presentation/bloc/main_event.dart';
import 'package:quran/features/presentation/bloc/main_state.dart';
import 'package:quran/features/presentation/widget/gradient_circle.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRecording = false; // This flag controls the rotation
  late AudioRecorder _recorder;
  final searchController = TextEditingController();
  File? file;
  List<SearchData> ayahs = [];
  bool isLoading = false;

  double height = 0.1;
  Reciter? reciter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Adjust rotation speed
      vsync: this,
    );
    _recorder = AudioRecorder();
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorder.dispose();
    searchController.dispose();
    super.dispose();
  }

  void toggleRotation() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _controller.repeat(); // Continue the rotation
      } else {
        _controller.reset(); // Reset to the default position
      }
    });
  }

  Future<bool> checkPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> toggleRecording() async {
    if (await _recorder.hasPermission()) {
      if (_isRecording) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recording Stopped'),
        ));
        await _recorder.stop();
        if (file != null) {
          BlocProvider.of<MainBloc>(context).add(DetectReciterEvent(file: file!));
        }
      } else {
        final directory = await getApplicationDocumentsDirectory(); // or getTemporaryDirectory()
        final filePath = '${directory.path}/saved.mp3';

        file = File(filePath);
        if (await file?.exists() == true) {
          await file?.delete(); // Delete the file if it exists
        }
        await _recorder.start(const RecordConfig(), path: filePath);
        // final stream = await _recorder.startStream(const RecordConfig());
      }
      toggleRotation();
    }
  }

  String? buildReciterUrl(String serverUrl) {
    // Use a regular expression to find the segment between slashes
    RegExp regExp = RegExp(r"https://[^/]+/([^/]+)");
    String? reciter = regExp.firstMatch(serverUrl)?.group(1);

    // Check if reciter is not null and build the new URL
    if (reciter != null) {
      return "https://mp3quran.net/ar/$reciter";
    } else {
      return null; // Return null if no valid reciter segment found
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(buildReciterUrl(urlString) ?? '');
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchDialog = Dialog(
        child: Container(
      decoration: BoxDecoration(
          color: Color(0xFF333333), borderRadius: BorderRadius.all(Radius.circular(16))),
      width: 350,
      height: 300,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 24,
              ),
              Text(
                'البحث عن',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: searchController,
                    decoration: const InputDecoration(
                        hintText: 'اكتب هنا ما تريد البحث عنه',
                        fillColor: Color(0xFF252525),
                        filled: true,
                        hintStyle: TextStyle(color: Color(0xFF515151))),
                  )),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () => BlocProvider.of<MainBloc>(context)
                      .add(SearchQuranEvent(content: searchController.text)),
                  child: Text('بحث'))
            ]),
          )),
    ));
    return BlocConsumer<MainBloc, MainState>(listener: (context, state) {
      if (state is MainLoading) {
        setState(() {
          isLoading = true;
          height = 0.1;
        });
      } else if (state is MainReciterDetected) {
        setState(() {
          isLoading = false;
          height = 0.3;
        });
        reciter = state.reciter;
      } else if (state is MainSearchResultLoaded) {
        setState(() {
          isLoading = false;
          Navigator.pop(context);
          ayahs = state.result.resultText;
          height = 0.8;
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFF252525),
        body: Stack(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4F4F4F),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.search, color: Color(0xFF252525)),
                            ),
                          ),
                        ),
                        onTap: () => showDialog(
                            context: context, builder: (BuildContext context) => searchDialog),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4F4F4F),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.mic, color: Color(0xFF252525)),
                            ),
                          ),
                        ),
                        onTap: () => print('Mic tapped'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                            child: RotationTransition(
                              turns: _controller,
                              child: GradientCircle(size: 200, borderWidth: 20),
                            ),
                            onTap: () => toggleRecording()),
                        const SizedBox(height: 60),
                        Text(_isRecording ? 'جار التسجيل' : 'اضغط اعلي للتعرف علي الصوت',
                            style: const TextStyle(color: Color(0xFFDBDBDB))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            reciter != null
                ? DraggableScrollableSheet(
                    initialChildSize: height,
                    // Initial size of the bottom sheet as a fraction of the screen height
                    minChildSize: 0.1,
                    maxChildSize: 0.8,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF333333),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  reciter?.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF3E3E3E),
                                  ),
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF3E3E3E),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Color(0xFF252525),
                                            size: 100,
                                          ),
                                        ),
                                      )),
                                ),
                                onTap: () => _launchUrl(reciter?.moshaf.server ?? ''),
                              )
                            ],
                          ));
                    },
                  )
                : const SizedBox(),
            ayahs.isNotEmpty
                ? DraggableScrollableSheet(
                    initialChildSize: height,
                    // Initial size of the bottom sheet as a fraction of the screen height
                    minChildSize: 0.1,
                    maxChildSize: 0.8,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF333333),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                for (var ayah in ayahs)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Text(ayah.ayahNoSurah.toString(),
                                              style: TextStyle(color: Colors.white, fontSize: 18)),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            ayah.surahNameAr!,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: Colors.white, fontSize: 18),
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.end,
                                      ),
                                      Text(ayah.ayahAr!,
                                          style:
                                              TextStyle(color: Colors.white, fontFamily: 'Amiri'), textAlign: TextAlign.end,),
                                      Text(ayah.tafsir!,
                                          style:
                                              TextStyle(color: Colors.white, fontFamily: 'Amiri'), textAlign: TextAlign.end,)
                                    ]),
                                  )
                              ],
                            ),
                          ));
                    },
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }
}
