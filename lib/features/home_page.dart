import 'package:flutter/material.dart';
import 'detection_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: const Color(0xFF15131C),
        title: Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: -1.0).animate(_controller),
              child: Image.asset(
                'assets/images/main-logo-white2.png',
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            Image.asset(
              'assets/images/main-logo-1.png',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: InkWell(
              radius: 5,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/loading-logo.png',
                    fit: BoxFit.cover,
                    width: 498,
                    height: 373,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(244, 243, 243, 1),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const SettingsWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(244, 243, 243, 1),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const DetectionWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Let's Detect ",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 24,
                        color: Color.fromARGB(255, 160, 29, 20),
                      ),
                    ],
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Info about app',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '''
Цей застосунок призначений для упередження загрози шляхом використання радару та камери.
Основна його мета - надати користувачам зручний і ефективний інструмент для виявлення потенційних 
загроз та забезпечення їх безпеки.
                  ''',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
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
