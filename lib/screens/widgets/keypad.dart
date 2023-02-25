import 'package:flutter/material.dart';

class KeyPad extends StatefulWidget {
  TextEditingController controller;
  Function buttonPressed;
  KeyPad({Key? key, required this.controller, required this.buttonPressed}) : super(key: key);

  @override
  _KeyPadState createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red.shade100)),
      shadowColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        height: 230,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.red.withOpacity(0.1),
          //     spreadRadius: 2,
          //     blurRadius: 2,
          //     offset: Offset(0, 0), // changes position of shadow
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildbutton("7"),
                  buildbutton('8'),
                  buildbutton('9'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildbutton('4'),
                  buildbutton('5'),
                  buildbutton('6'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildbutton('1'),
                  buildbutton('2'),
                  buildbutton('3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildbutton(''),
                  buildbutton('0'),
                  buildbutton('X'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildbutton(String buttonText) {
    return new Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        height: 50,
        child: new ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.red.shade100;

                return Colors.white; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.white))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.red.shade50;

                return Colors.white; // Use the component's default.
              },
            ),
          ),
          child: buttonText == "X"
              ? Container(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.red.shade400,
                    ),
                    onPressed: () => {widget.buttonPressed(buttonText)},
                  ))
              : new Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
          onPressed: () => {widget.buttonPressed(buttonText)},
        ),
      ),
    ));
  }
}
