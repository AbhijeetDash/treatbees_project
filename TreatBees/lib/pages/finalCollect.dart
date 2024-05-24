import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';

class FinalCollect extends StatefulWidget {
  final String cafeCode;
  final String orderID;
  final String userMail;
  final String date;

  const FinalCollect(
      {Key key, this.cafeCode, this.orderID, this.userMail, this.date})
      : super(key: key);
  @override
  _FinalCollectState createState() => _FinalCollectState();
}

class _FinalCollectState extends State<FinalCollect>
    with SingleTickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;

  bool _isTorchOn = false;

  String _captureText = '';

  void doneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Collected",
                  style: MyFonts().smallHeadingBold,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Enjoy your meal",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.orange,
                  height: 30,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      _captureController.pause();
      if (data == widget.cafeCode) {
        FirebaseCallbacks()
            .updateOrderStatus(
                "collected", data, widget.orderID, widget.userMail, widget.date)
            .then((value) => {doneDialog(context)});
      }
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 250,
            height: 250,
            child: QRCaptureView(
              controller: _captureController,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 56),
            child: AspectRatio(
              aspectRatio: 264 / 258.0,
              child: Stack(
                alignment: _animation.value,
                children: <Widget>[
                  Image.asset('assets/sao@3x.png'),
                  Image.asset('assets/tiao@3x.png')
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Text(
                "Scan cafe QR to\npick-up your order",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildToolBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    Icon icon = Icon(Icons.flash_off);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            if (_isTorchOn) {
              _captureController.torchMode = CaptureTorchMode.off;
              setState(() {
                icon = Icon(Icons.flash_off);
              });
            } else {
              _captureController.torchMode = CaptureTorchMode.on;
              setState(() {
                icon = Icon(Icons.flash_on);
              });
            }
            _isTorchOn = !_isTorchOn;
          },
          icon: icon,
        ),
      ],
    );
  }
}
