import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:treatbees_business/utils/theme.dart';

class ViewQR extends StatefulWidget {
  final String code;

  const ViewQR({Key key, this.code}) : super(key: key);
  @override
  _ViewQRState createState() => _ViewQRState();
}

class _ViewQRState extends State<ViewQR> {

  Future<bool> checkPermissions() async {
    Permission.storage.request().then((value) {});
    var status = await Permission.storage.status;
    return status.isGranted;
  }

  @override
  void initState() {
    super.initState();
  }

  void doneDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context){
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
                    "Downloaded",
                    style: MyFonts().smallHeadingBold,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Check Download folder to view the pdf\nWe suggest printing it out\nto make process easier",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
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
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        title: Text("My QR-Code"),
      ),
      body: Container(
        color: MyColors().alice,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                "Ask users to scan this code to complete pick-up",
                style: MyFonts().smallHeadingBold,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors().shadowDark,
                      MyColors().alice,
                    ]),
                boxShadow: [
                  BoxShadow(
                      color: MyColors().shadowDark,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15,
                      spreadRadius: 1),
                  BoxShadow(
                      color: MyColors().shadowLight,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15,
                      spreadRadius: 1)
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(
                    errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                  ),
                  data: widget.code,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RawMaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Download QR Code"),
                ),
                fillColor: Colors.orange,
                shape: StadiumBorder(),
                onPressed: () {
                  final doc = pw.Document();
                  doc.addPage(
                    pw.Page(
                        build: (pw.Context context) => pw.Center(
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: pw.Text(
                                        "Ask users to scan this code to complete pick-up",
                                        style: pw.TextStyle(
                                            fontSize: 20,
                                            fontWeight: pw.FontWeight.bold),
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    ),
                                    pw.SizedBox(height: 50),
                                    pw.BarcodeWidget(
                                      barcode: Barcode.qrCode(
                                        errorCorrectLevel:
                                            BarcodeQRCorrectionLevel.high,
                                      ),
                                      data: widget.code,
                                      width: 200,
                                      height: 200,
                                    ),
                                  ]),
                            )),
                  );
                  checkPermissions().then((value){
                    if(value){
                      File file;
                      Directory path;
                      print(path);
                      getExternalStorageDirectory().then((value) => {
                        path = new Directory.fromUri(Uri(
                            path:
                            '${value.path.split('/Android')[0]}/Download')),
                        file = new File('${path.path}/CafeQR.pdf'),
                        file.writeAsBytesSync(doc.save())
                      });
                      doneDialog(context);
                    }
                  });
                })
          ],
        ),
      ),
    );
  }
}
