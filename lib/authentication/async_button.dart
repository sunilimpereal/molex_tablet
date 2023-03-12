import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

enum AsyncButtonState {
  loading,
  active,
}

class AsyncButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final double width;
  final double height;
  const AsyncButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width = 200,
    this.height = 45,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  AsyncButtonState state = AsyncButtonState.active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return Colors.white;
              return Colors.white; // Use the component's default.
            },
          ),
          elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
            return 10;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return Colors.green;
              return state == AsyncButtonState.loading ? Colors.grey.shade400 : Colors.red; // Use the component's default.
            },
          ),
        ),
        onPressed: () async {
          if (state == AsyncButtonState.active) {
            setState(() {
              state = AsyncButtonState.loading;
            });
            await widget.onPressed();
            setState(() {
              state = AsyncButtonState.active;
            });
          }
        },
        child: state == AsyncButtonState.loading ? loading() : widget.child,
      ),
    );
  }

  Widget loading() {
    return Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
          Center(
            child: Container(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final String text;
  const ButtonText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // 'Machine Login',
      // style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}
