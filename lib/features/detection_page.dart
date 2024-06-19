import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:diploma/data/setting_model_data.dart';
import 'package:flutter/material.dart';
import 'package:image_compare/image_compare.dart';
import 'package:path_provider/path_provider.dart';

class DetectionWidget extends StatefulWidget {
  const DetectionWidget({super.key});

  @override
  State<DetectionWidget> createState() => _DetectionWidgetState();
}

class _DetectionWidgetState extends State<DetectionWidget>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;

  // Constant parameters
  CameraController? _controller;
  bool inProgress = false;
  int _indexOfImageTaken = 0;
  double diffPercentage = 0;
  final List<String> _listOfPathsToImages = [];

  // Setting parameters
  double tickRate = SettingDetails().settingsData.tickrate;
  int thresholdPercentage = SettingDetails().settingsData.percentValue;
  bool soundValue = SettingDetails().settingsData.switchValue;

  // Animation parameters
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _audioPlayer = AudioPlayer();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.8),
    ).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    try {
      _controller = CameraController(firstCamera, ResolutionPreset.medium);
      await _controller?.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _takePhotos() async {
    try {
      final image = await _controller?.takePicture();
      if (image == null) return;

      // save the image to the file system
      final docsDirectoryPath = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$docsDirectoryPath/$_indexOfImageTaken';
      await image.saveTo(filePath);

      _indexOfImageTaken++;
      if (_listOfPathsToImages.length < 10) {
        _listOfPathsToImages.add(filePath);
      } else {
        _listOfPathsToImages.removeAt(0);
        _listOfPathsToImages.add(filePath);
      }
    } catch (e) {
      print('Error taking photos: $e');
    }
  }

  Future<double> findDiff() async {
    double totalDiffPercentage = 0;
    int comparisons = 0;
    if (_listOfPathsToImages.length > 1) {
      for (int i = 0; i < _listOfPathsToImages.length; i++) {
        for (int j = i + 1; j < _listOfPathsToImages.length; j++) {
          final diffPercentage = await compareImages(
              src1: File(_listOfPathsToImages[i]),
              src2: File(_listOfPathsToImages[j]));
          totalDiffPercentage += diffPercentage;
          comparisons++;
        }
      }
    }
    // Calculate the average difference percentage
    double averageDiffPercentage = totalDiffPercentage / comparisons;

    return averageDiffPercentage;
  }

  void detectMotion(int thresholdPercentage, int tickrate) {
    print('!!!\n\nStart detection\n\n!!!');
    Timer.periodic(Duration(seconds: tickrate), (timer) async {
      _takePhotos();
      diffPercentage = await findDiff();
      setState(() {
        diffPercentage = diffPercentage * 100;
      });
      print('Percent: $diffPercentage');
      if (diffPercentage > thresholdPercentage) {
        showMotionDetectedMessage();
        inProgress = false;
        print('!!!\n\nStop detection\n\n!!!');
        timer.cancel(); // Stop the timer when motion is detected
      }

      if (inProgress == false) {
        timer.cancel();
      }
    });
  }

  void showMotionDetectedMessage() {
    _animationController.forward();
    if (soundValue == true) {
      _audioPlayer.play(AssetSource('audio/alarm.mp3'));
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Container(
                  color: _colorAnimation.value,
                );
              },
            ),
            AlertDialog(
              alignment: Alignment.center,
              title: const Text('ALARM'),
              content:
                  const Text('Found a potential hazard, check it yourself'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Ok');
                    _animationController.stop();
                    _audioPlayer.pause();
                  },
                  child: const Text('Ok'),
                ),
              ],
            ),
          ],
        );
      },
    );
    print('Warning detected!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: const Color(0xFF15131C),
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: InkWell(
            radius: 7,
            borderRadius: BorderRadius.circular(30),
            splashColor: const Color.fromARGB(255, 49, 34, 97),
            focusColor: const Color.fromARGB(255, 49, 34, 97),
            hoverColor: const Color.fromARGB(255, 49, 34, 97),
            highlightColor: Colors.transparent,
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: InkWell(
              radius: 7,
              borderRadius: BorderRadius.circular(30),
              splashColor: const Color.fromARGB(255, 49, 34, 97),
              focusColor: const Color.fromARGB(255, 49, 34, 97),
              hoverColor: const Color.fromARGB(255, 49, 34, 97),
              highlightColor: const Color.fromARGB(255, 49, 34, 97),
              onTap: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) => _buildBottomSheet()),
              child: const Icon(
                Icons.info_outline,
                color: Color.fromRGBO(143, 100, 73, 1),
                size: 27,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.width * 1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: _controller?.value.isInitialized == true
                      ? CameraPreview(_controller!)
                      : Container(),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 39, 33, 63),
                ),
                child: Text(
                  (diffPercentage == 0 && inProgress == false) ||
                          (diffPercentage.isNaN || diffPercentage.isInfinite)
                      ? "Text of percentage %"
                      : "Text of percentage: ${diffPercentage.toStringAsFixed(3)}",
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Container(
                height: 56.0,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (inProgress == false) {
                      setState(() {
                        inProgress = true;
                      });
                      detectMotion(thresholdPercentage, tickRate.toInt());
                    } else {
                      setState(() {
                        inProgress = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                  ),
                  child: Text(
                    !inProgress ? 'Start' : 'Stop',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 15),
          height: 5,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black45,
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: Color.fromARGB(255, 196, 196, 196),
                  size: 30,
                ),
                Icon(Icons.close_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Info about settings',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '''
1. Використовуйте додаток для виявлення руху. З його допомогою ви можете легко виявити будь-які рухи або активність у визначеному просторі.

2. Натисніть кнопку "Почати", щоб розпочати процес виявлення. Після запуску програми вам буде доступно реальнорядний аналіз оточуючого простору.

3. Додаток повідомить вас про будь-який виявлений рух. Буде наданий світловий сигнал та звуковий. (Примітка: Не згортайте додаток)
                  ''',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
