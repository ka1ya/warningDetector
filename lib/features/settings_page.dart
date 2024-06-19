import 'package:diploma/data/setting_model_data.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TextEditingController _textFieldController = TextEditingController();
  double textFieldValue = 3;
  double _currentSliderPrimaryValue = 5;
  int perCentValue = 5;
  bool _switchValue = true;

  void _setValueFromTextField() {
    setState(() {
      textFieldValue = double.parse(_textFieldController.text);
    });
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.check,
          color: Colors.black,
        );
      }
      return const Icon(Icons.close, color: Colors.black);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
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
              const SizedBox(height: 30),
              Container(
                height: 330,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromRGBO(255, 255, 255, 0.75),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _textFieldController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tickrate',
                          hintText: '3',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          _setValueFromTextField();
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      alignment: Alignment.center,
                      height: 144,
                      width: MediaQuery.of(context).size.width * 0.85,
                      //padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              'Percentage of detect: $perCentValue',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Slider(
                            max: 99,
                            min: 1,
                            value: _currentSliderPrimaryValue,
                            label:
                                _currentSliderPrimaryValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderPrimaryValue = value;
                                perCentValue = value.round();
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Turn on sound',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Switch(
                                  thumbIcon: thumbIcon,
                                  value: _switchValue,
                                  trackColor: MaterialStatePropertyAll(
                                    _switchValue
                                        ? const Color.fromRGBO(103, 80, 164, 1)
                                        : const Color.fromRGBO(63, 50, 100, 1),
                                  ),
                                  inactiveThumbColor: Colors.white,
                                  trackOutlineColor:
                                      const MaterialStatePropertyAll(
                                          Colors.transparent),
                                  onChanged: (bool value) {
                                    setState(() {
                                      _switchValue = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '*Dont forget turn on sound!!!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(244, 243, 243, 1),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      SettingDetails().updateSettings(
                          textFieldValue, perCentValue, _switchValue);

                      print(
                          '\n\ntickRate: ${SettingDetails().settingsData.tickrate}, thresholdPercentage: ${SettingDetails().settingsData.percentValue}, soundValue: ${SettingDetails().settingsData.switchValue} \n\n');
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
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
Tickrate - це параметр в якому Ви вказуєте період через який робиться фото. (Рекомендовані значення від 3 до 5)

Percentage of detectв - це відсоткове значення різниці, якщо значення вказане Вами буде перевищено під час процесу виявлення, то спрацює ТРИВОГА! (Рекомендації варто підбирати відсоток відносно місцевості та відстані до ймовірної небезпеки)

Sound - параметр увімкнення звуку при виявленні потенційної небезпеки (Рекомендації якщо пристрій буде знаходитись у Вашому полі зору, то можете вимкнути перемикач)
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
